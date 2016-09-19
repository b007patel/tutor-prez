// Modified example code from
//        http://toolsqa.com/selenium-webdriver/page-object-pattern-model-page-factory/
//        accessed on Aug 23, 2016
package test.pageobjects;

import java.sql.SQLException;
import java.util.*;
import java.io.*;

import org.openqa.selenium.*;
import org.openqa.selenium.support.*;

/*import org.jsoup.nodes.*;
import org.jsoup.parser.*;*/

public class ChemRxnBalancer_PG_POF {

    final WebDriver webdrv;

    private static String static_elem_tbl =
            Localization.init().ChemRxnBal_ST.get(Locale.US.toLanguageTag());

    private static Properties staticElems = new Properties();

    private Random rnd;

    @FindBy(how = How.ID, using = "reaction")
    @CacheLookup
    public WebElement txt_Reaction;

    @FindBy(how = How.ID, using = "bal_button")
    @CacheLookup
    public WebElement btn_Balance;

    @FindBy(how = How.ID, using = "rxn_unbal")
    public WebElement div_startrxn;

    @FindBy(how = How.ID, using = "rxn_bal")
    public WebElement div_balrxn;

    @FindBy(how = How.ID, using = "rxn_warns")
    public WebElement div_warns;

    @FindBy(how = How.ID, using = "rxn_errors")
    public WebElement div_errors;

    @FindBy(how = How.ID, using = "rxn_steps")
    public WebElement div_steps;

    @FindBy(how = How.ID, using = "extra_steps")
    public WebElement div_ua_steps;

    public WebElement getReactionFromDiv(WebElement rdiv)
           throws Exception {
        WebElement rxn = rdiv.findElement(By.tagName("font"));
        return rxn;
    }

    public WebElement getStep(int stepnum) {
        String stepid = "step_";
        stepid += Integer.toString(stepnum);
        return this.webdrv.findElement(By.id(stepid));
    }

    public WebElement getWorksheet(int stepnum) {
        String wksid = "wks_st";
        wksid += Integer.toString(stepnum);
        return this.webdrv.findElement(By.id(wksid));
    }

    /**
     * Use input to make a step HTML element. Used by data-driven testing
     * @param stepid desired step ID
     * @param steptext desired step text
     * @return a step HTML element based on stepid and steptext
     */
    public String formatStep(int stepid, String steptext) {
        String raw_html = String.format("<li id=\"step_%d\"><span " +
                "class=\"stepnum\">(%d) </span>%s</li>", stepid, stepid,
                steptext);
        return raw_html;
    }

    /**
     * Use input to make an error HTML element. Used by data-driven testing
     * @param errtext desired step text
     * @return an error HTML element based on errtext
     */
    public String formatErr(String errtext) {
        return errtext;
    }

    /**
     * Use input to make a warning HTML element. Used by data-driven testing
     * @param warntext desired step text
     * @return a warning HTML element based on warntext
     */
    public String formatWarn(String warntext) {
        return warntext;
    }

    /**
     * Use input to make an HTML worksheet line item. Used by data-driven testing
     * @param wksid worksheet step ID
     * @param elem chemical element's symbol
     * @param rxcnt elem's atom count on reactant side
     * @param prcnt elem's atom count on product side
     * @return a worksheet div element, and a worksheet line item element
     */
    public String[] formatWksRow(int wksid, String elem, int rxcnt,
            int prcnt) {
        String[] rv = {"", ""};
        String raw_html = String.format("<div id=\"wks_st%d\" " +
                "class=\"bdrtop wksheet\">", wksid);
        rv[0] = raw_html;
        raw_html = String.format("<table><tr><td>%s</td>" +
                "<td class=\"num\">%d</td><td class=\"num\">%d</td>" +
                "</tr></table>", elem, rxcnt, prcnt);
        rv[1] = raw_html;
        return rv;
    }

    /**
     * Causes failures during Chem Reaction Balancer testing by returning
     * an incorrect set of expected data. The data changes randomly.
     *
     * Useful for demonstrating or testing test failure logging gear.
     *
     * @param cid - test case ID of the desired failing case
     * @param stype_id - verify step type of the specific failing step
     * @param dbstep - current "correct" expected output
     * @return
     * @throws SQLException
     */
    public String causeFailure(Integer cid, Integer stype_id, String dbstep)
            throws SQLException {
        String rv = dbstep, sterm;
        int failtype = rnd.nextInt(3);
        int tpos;

        // double-check resources/data/<dbms>/test_data.sql to confirm
        // correct values of vs_type_id for switch (stype_id) statement
        switch (stype_id) {
            case 0:
                sterm = "cpd_";
                switch (failtype) {
                    case 0: //reaction
                        rv = rv.replaceFirst(sterm, sterm + "Zn2");
                        if (rv.equals(dbstep)) rv =
                                rv.replaceFirst(" ", " _ ");
                        break;
                    case 1:
                        tpos = rv.indexOf(sterm);
                        if (tpos > 0) {
                            int clq = rv.indexOf("\"", tpos);
                            String delterm = rv.substring(tpos, clq);
                            rv = rv.replaceFirst(delterm, sterm);
                        } else {
                            StringTokenizer st = new StringTokenizer(rv,
                                    " ", true);
                            int numtokens = st.countTokens(), skiptoken = 3;
                            String ct;
                            if (numtokens > 1) {
                                try {
                                    rv = "";
                                    numtokens = 1;
                                    // delete first token past "+" sign
                                    while (st.hasMoreTokens()) {
                                        ct = st.nextToken();
                                        if (numtokens != skiptoken) {
                                            rv += ct;
                                        } else {
                                            if (ct.equals(" ") ||
                                                    ct.equals("+")) {
                                                rv += ct;
                                                skiptoken++;
                                            }
                                        }
                                        numtokens++;
                                    }
                                } catch (Exception e) {
                                    // should only happen if dbstep of form
                                    // "<term> +"
                                    numtokens = 1;
                                }
                            } else {
                                rv = st.nextToken().substring(1);
                            }
                        }
                        break;
                    case 2:
                        tpos = rv.indexOf(sterm) + sterm.length();
                        String findterm = "", repterm = "";
                        if (rv.indexOf(sterm) < 1) {
                            tpos = 0;
                        }
                        findterm = rv.substring(tpos,  tpos + 2);
                        String char2 = findterm.substring(1, 2);
                        boolean onechar = char2.equals("(");
                        if (!onechar) {
                            onechar = ((char2.compareTo("0") >= 0) &&
                                    (char2.compareTo("9") <= 0));
                        }
                        if (!onechar) {
                            onechar = ((char2.compareTo("A") >= 0) &&
                                    (char2.compareTo("Z") <= 0));
                        }
                        if (onechar) {
                            findterm = findterm.substring(0, 1);
                            repterm = "O";
                            if (findterm.startsWith("O")) repterm = "S";
                        } else {
                            repterm = "Zn";
                            if (findterm.equals("Zn")) repterm = "Mn";
                        }
                        rv = rv.replaceFirst(findterm, repterm);
                        break;
                    }
                break;
            case 1: case 2: //step and extrastep
                sterm = "Consider compounds with";
                String insterm = "Consider the compounds with";
                String delterm = "Consider compounds";
                String repterm = "Consider tragedies with";
                if (rv.indexOf(sterm) < 0) {
                    sterm = "balance";
                    insterm = "the balance";
                    delterm = "bale";
                    repterm = "valence";
                }
                switch (failtype) {
                    case 0:
                        rv = rv.replaceFirst(sterm, insterm);
                        break;
                    case 1:
                        rv = rv.replaceFirst(sterm, delterm);
                        break;
                    case 2:
                        rv = rv.replaceFirst(sterm, repterm);
                        break;
                }
                break;
            case 3: //error
                sterm = "eactant";
                if (rv.contains(sterm)) {
                    insterm = "eactingant";
                    delterm = "eact";
                    repterm = "idgeway";
                } else {
                    sterm = "roduct";
                    insterm = "rovingduct";
                    delterm = "rout";
                    repterm = "erfect";
                }
                switch (failtype) {
                    case 0:
                        rv = rv.replaceFirst(sterm, insterm);
                        break;
                    case 1:
                        rv = rv.replaceFirst(sterm, delterm);
                        break;
                    case 2:
                        rv = rv.replaceFirst(sterm, repterm);
                        break;
            }
            break;
            case 5: //worksheet
                switch (failtype) {
                case 0:
                    rv = rv.replaceFirst("<td class=\"num\">",
                            "<td class=\"num\">#");
                    break;
                case 1:
                    rv = rv.replaceFirst("<td class=\"num\">[1-9][0-9]*</td>",
                            "<td class=\"num\"></td>");
                    break;
                case 2:
                    rv = rv.replaceFirst("<td>X", "<td>Z");
                    if (dbstep.equals(rv)) {
                        rv = rv.replaceFirst("<td>[A-Z]", "<td>X");
                    }
                    break;
            }
            break;
        }
        return rv;
    }

    public void setRandomGen(Random rnd_in) {rnd = rnd_in;}

    public ChemRxnBalancer_PG_POF(WebDriver drv) throws BadPgObjException {
        webdrv = drv;
        try {
            staticElems.load(new StringReader(static_elem_tbl));
        } catch (IOException ioe) {
            // do nothing
        }
        String cur_title = webdrv.getTitle();
        //System.out.println("Title is: '" + cur_title + "'");
        if (!cur_title.equals(staticElems.get("title"))) {
            throw new BadPgObjException("Bad page title '" + cur_title + "'");
        }
    }
}
