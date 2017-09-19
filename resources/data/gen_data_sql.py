# accepts an argument of dbtype, validated against a list of known dbtypes
# creates an sql file based on inputs in database. These inputs are
# maintained manually in test_data.sql
import sys, os
from optparse import OptionParser
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
import MySQLdb
from ChemRxnBalancer_PG import ChemRxnBalancer_PG

DEFAULT_TC_OUTPUT_SQLFILE = "test_case_data.sql"
rxn_start = 'insert into "verify_reaction" ("reaction_type", "case_id", ' +\
        '"vr_text")\n    values (\n    '
step_start = 'insert into "verify_step" ("vs_type_id", "case_id", ' +\
        '"vs_text")\n    values ('

# may want to put this in coreesponding PageObject class
def getStepStatements(stdiv, cid, extra):
    rv = ""
    steps = stdiv.find_elements_by_tag_name("li")
    stype = "2" if extra else "1"
    for st in steps:
        stepstr = st.get_attribute("innerHTML").strip()
        first_span_end = stepstr.find(">") + 1
        first_span_end = stepstr.find(">", first_span_end) + 1
        stepstr = stepstr[first_span_end:]
        stepstr = stepstr.replace("'", "\\'")
        stepstr = stepstr.replace(";", "\\;")
        step_num = st.get_attribute("id")[5:]
        rv += step_start + stype + ', ' + cid + ",\n    '" + step_num + "|" +\
                stepstr + "');\n"
    # when per-step worksheets are available, use code below
    #   wks = crbpg.getWorksheet(step_num)
    #   rv = getWksRows(wks, step_num, str(cid), 1)
    #return rv
    # when per-step worksheets are not available, use code below
    return (rv, step_num)

def getWksRows(wksdiv, stnum, cid, indent_l=0):
    rv = ""
    # for each worksheet row
    for wk in wksdiv.find_elements_by_tag_name("tr"):
        if (wk.get_attribute("class") != "tbl_header"):
            rv += ("\t" * indent_l) + step_start + "5, " + cid + ",\n    '" +\
                    stnum
            for cell in wk.find_elements_by_tag_name("td"):
                rv += ',' + cell.text
            rv +=  "');\n"
    return rv

def get_cl_args(parser):
    exec_fname = os.path.realpath(__file__)
    resdata_dir = os.sep + "resources" + os.sep + "data"
    repos_path = exec_fname[:exec_fname.find(resdata_dir)]
    default_dbprops = repos_path + os.sep + "test" + os.sep + "db.props"
    usage = "%prog [options]\n" + "=" * 70 + "\n" +\
            "Generate test case verification data based on test input in " +\
            "database"
    parser.usage = usage
    parser.add_option("-f", "--file", dest="filename", \
            default=DEFAULT_TC_OUTPUT_SQLFILE, help=\
            "output SQL file containing verification data. Default is " +\
            DEFAULT_TC_OUTPUT_SQLFILE)
    parser.add_option("-d", "--dbprops", dest="dbprops_file", \
            default=default_dbprops, help=\
            "properties file containing DB connection info. Default is " +\
            default_dbprops)
    (opts, args) = parser.parse_args()

    dbprops_ok = True
    try:
        fsz = os.path.getsize(opts.dbprops_file)
        dbprops_ok = fsz > 5
    except:
        dbprops_ok = False
    if not dbprops_ok:
        parser.error("\n==> DB properties file " + opts.dbprops_file +\
                " is not a valid file!")

    exit_py = False
    try:
        fsz = os.path.getsize(opts.filename)
        print "The file '{!s}' exists.".format(opts.filename)
        reply = raw_input("Overwrite?(y/N)> ")
        if (not reply.lower().startswith("y")):
            exit_py = True
    except:
        # file does not exist. Ok to make a new one
        pass
    print
    if exit_py:
        sys.exit(0)
    return opts

def main():
    parser = OptionParser()
    opts = get_cl_args(parser)
        
    with open(opts.dbprops_file) as f:
        for line in f:
            if (line.find("dbms") > 0):
                dbms = line[line.find(">") + 1:line.rfind("<")]
            if (line.find("database_name") > 0):
                dbname = line[line.find(">") + 1:line.rfind("<")]
            if (line.find("user") > 0):
                dbuser = line[line.find(">") + 1:line.rfind("<")]
            if (line.find("password") > 0):
                dbpwd = line[line.find(">") + 1:line.rfind("<")]

    try:
        dummy = dbms
        dummy = dbname
    except UnboundLocalError:
        parser.error("\n==> DB props file " + opts.dbprops_file +\
                " exists, but is an invalid format")

    # output db-specific preamble, if any (e.g., use <dbname>)

    # may be replaced with a method to get a long-form DBMS name
    dbms_name = dbms
    pre_script = "-- " + dbms_name + "-specific preamble, if any\n";
    if (dbms == "mysql"):
        pre_script += "set sql_mode='ANSI_QUOTES';\n"
        if ((dbname != None) and (len(dbname) > 1)):
            pre_script += "use " + dbname + ";\n"
    pre_script += "-- end " + dbms_name + " preamble\n"

    db = MySQLdb.connect(host="localhost", user=dbuser,
            passwd=dbpwd, db="chemtest")
    cur = db.cursor()
    # do not use "'s below around identifier names. Do not have 
    # ANSI quotes enabled for this connection to mysql
    cur.execute("SELECT sc.case_id, sc.suite_id, tc.case_desc, " +\
            'tc.case_exec FROM test_case tc, suite_case sc ' +\
            "where sc.case_id = tc.case_id")

    outf = open(opts.filename, "w")
    print >> outf, pre_script

    for row in cur.fetchall():
        cid = row[0]
        cidstr = str(cid)
        sid = row[1]
        sidstr = str(sid)
        cdesc = row[2]
        action = row[3]

        print "Writing statements for test case ID " + str(cid)

        # load page, submit current reaction
        try:
            wd = webdriver.Chrome()
            wd.get("https://bbaero.freeddns.org/tutor-prez/" +\
                    "web/chem/balance.php")
            crbpg = ChemRxnBalancer_PG(wd)
            is_error = sid == 2
            #print "CID {:d}, Suite ID {:d}{!s}".format(cid, sid, slabel)
            #print "rxn: {!s}\n".format(action)
            crbpg.txt_Reaction.send_keys(action + Keys.RETURN)

            # if present, get error reaction and steps
            if (is_error):
                try:
                    errdiv = WebDriverWait(wd, 5).until(
                            lambda wd: wd.find_element_by_id(crbpg.errors_id))
                    rxn = crbpg.getReactionFromDiv(errdiv).get_attribute(
                            "innerHTML").strip()
                    cur_stmt = rxn_start + "1, " + cidstr + ",\n    '" +\
                            rxn + "');\n"
                    print >> outf, "-- Test case {:d}, {!s}".format(cid, cdesc)
                    print >> outf, "-- Reaction: {!s}".format(action)
                    print >> outf, cur_stmt
                    cur_stmt = ""
                    errors = errdiv.find_elements_by_tag_name("li")
                    for err in errors:
                        errstr = err.get_attribute("innerHTML").strip()
                        errstr = errstr.replace("'", "\\'")
                        errstr = errstr.replace(";", "\\;")
                        cur_stmt += step_start + '3, ' + cidstr + ",\n    '" +\
                                errstr + "');\n"
                    print >> outf, cur_stmt
                    continue
                except:
                    print ">>Error div not found, so this case must exceed " +\
                            "step limit"

            # error not found, get 'regular' reactions
            rxndiv = WebDriverWait(wd, 40).until(
                    lambda wd: wd.find_element_by_id(crbpg.startrxn_id))
            rxn = crbpg.getReactionFromDiv(rxndiv).get_attribute(
                    "innerHTML").strip()
            cur_stmt = rxn_start + "1, " + cidstr + ",\n    '" + rxn + "');\n"
            print >> outf, "-- Test case {:d}, {!s}".format(cid, cdesc)
            print >> outf, "-- Reaction: {!s}".format(action)
            print >> outf, cur_stmt
            # if number of max steps not exceeded
            if (not is_error):
                cur_stmt = ""
                rxndiv = WebDriverWait(wd, 40).until(
                        lambda wd: wd.find_element_by_id(crbpg.balrxn_id))
                rxn = crbpg.getReactionFromDiv(rxndiv).get_attribute(
                        "innerHTML").strip()
                cur_stmt += rxn_start + "2, " + cidstr + ",\n    '" + rxn +\
                        "');\n"
                print >> outf
                print >> outf, cur_stmt

            # if warning found
            cur_stmt = ""
            try:
                warndiv = wd.find_element_by_id(crbpg.warns_id)
                print ">>Warnings found for test case ID {:d}".format(cid)
                warnings = warndiv.find_elements_by_tag_name("li")
                for w in warnings:
                    warnstr = w.get_attribute("innerHTML").strip()
                    warnstr = warnstr.replace("'", "\\'")
                    warnstr = warnstr.replace(";", "\\;")
                    cur_stmt += step_start + '4, ' + cidstr + ",\n    '" +\
                            warnstr + "');\n"
                print >> outf
                print >> outf, cur_stmt
            except:
                # usual case is no warnings
                pass
                
            # for each step (visible or not)
            cur_stmt = ""
            stepdiv = wd.find_element_by_id(crbpg.steps_id)
            (cur_stmt, step_num) = getStepStatements(stepdiv, cidstr, False)
            try:
                ua_stepdiv = wd.find_element_by_id(crbpg.ua_steps_id)
                (ua_cur_stmt, step_num) = getStepStatements(ua_stepdiv,
                        cidstr, True)
                cur_stmt += ua_cur_stmt
            except:
                # no unabridged extra steps found
                pass
            # when per-step worksheets are not available, use code below
            wks = crbpg.getWorksheet(step_num)
            print >> outf
            print >> outf, cur_stmt
            
            cur_stmt = getWksRows(wks, step_num, str(cid))
            print >> outf
            print >> outf, cur_stmt
                
        finally:
            try:
                wd.quit()
            except:
                # cannot do anything further anyway
                pass
            try:
                db.close()
            except:
                # cannot do anything further anyway
                pass

if (__name__ == '__main__'):
    main()
