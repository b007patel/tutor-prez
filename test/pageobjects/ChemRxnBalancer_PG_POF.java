// Modified example code from
//        http://toolsqa.com/selenium-webdriver/page-object-pattern-model-page-factory/
//        accessed on Aug 23, 2016
package test.pageobjects;

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

    public ChemRxnBalancer_PG_POF(WebDriver drv) throws BadPgObjException {
        this.webdrv = drv;
        try {
            staticElems.load(new StringReader(static_elem_tbl));
        } catch (IOException ioe) {
            // do nothing
        }
        String cur_title = this.webdrv.getTitle();
        //System.out.println("Title is: '" + cur_title + "'");
        if (!cur_title.equals(staticElems.get("title"))) {
            throw new BadPgObjException("Bad page title '" + cur_title + "'");
        }
    }
}
