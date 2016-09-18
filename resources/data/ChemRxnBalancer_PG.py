import MySQLdb
import selenium
from selenium.webdriver.common.by import By

class ChemRxnBalancer_PG :

    def getReactionFromDiv(self, rdiv):
        rxn = None
        try:
            rxn = rdiv.find_element_by_tag_name("font")
        except (e):
            #elems = rdiv.find_elements_by_tag_name("font")
            #print "All font elems:"
            #print elems
            #print "------\n"
            #rxn = elems[0]
            print "Can't find font tag!!"
            #e.printStackTrace()
            raise e
            #rxn = rdiv
        return rxn

    def getStep(self, stepnum):
        stepid = "step_"
        stepid += str(stepnum)
        return self.webdrv.find_element_by_id(stepid)

    def getWorksheet(self, stepnum):
        wksid = "wks_st"
        wksid += str(stepnum)
        return self.webdrv.find_element_by_id(wksid)

    """
    Use input to make a step HTML element. Used by data-driven testing
    @param stepid desired step ID
    @param steptext desired step text
    @return a step HTML element based on stepid and steptext
    """
    def formatStep(self, stepid, steptext):
        raw_html = ("<li id=\"step_{:d}\"><span " +
                "class=\"stepnum\">({:d}) </span>{!s}</li>").format(
                    stepid, stepid, steptext)
        return raw_html

    """
    Use input to make an error HTML element. Used by data-driven testing
    @param errtext desired step text
    @return an error HTML element based on errtext
    """
    def formatErr(self, errtext):
        return errtext

    """
    Use input to make a warning HTML element. Used by data-driven testing
    @param warntext desired step text
    @return a warning HTML element based on warntext
    """
    def formatWarn(self, warntext):
        return warntext

    """
    Use input to make an HTML worksheet line item. Used by data-driven testing
    @param wksid worksheet step ID
    @param elem chemical element's symbol
    @param rxcnt elem's atom count on reactant side
    @param prcnt elem's atom count on product side
    @return a worksheet div element, and a worksheet line item element
    """
    def formatWksRow(self, wksid, elem, rxcnt, prcnt):
        rv = ["", ""]
        raw_html = '<div id="wks_st{:d}" class="bdrtop wksheet">'.format(wksid)
        rv[0] = raw_html
        raw_html = ('table><tr><td>{!s}</td><td class="num">{:d}</td>' +
                '<td class="num">{:d}</td></tr></table>').format(elem, rxcnt,
                    prcnt)
        rv[1] = raw_html
        return rv

    def __init__(self, drv):
        self.webdrv = drv

        self.startrxn_id = "rxn_unbal"

        self.balrxn_id = "rxn_bal"

        self.warns_id = "rxn_warns"

        self.errors_id = "rxn_errors"

        self.steps_id = "rxn_steps"

        self.ua_steps_id = "extra_steps"

        # no Python analog to @CacheLookup
        self.txt_Reaction = self.webdrv.find_element_by_id("reaction")

        # no Python analog to @CacheLookup
        self.btn_Balance = self.webdrv.find_element_by_id("bal_button")

        cur_title = self.webdrv.title
        #print "Title is: '" + cur_title + "'"
        if (cur_title != "Chemical Reaction Balancer (by Inspection)"):
            raise Exception("Bad page title '" + cur_title + "'")
