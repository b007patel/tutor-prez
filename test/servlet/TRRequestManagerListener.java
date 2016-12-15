package test.servlet;

import java.beans.PropertyChangeSupport;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeEvent;

import tputil.EasyUtil;

public class TRRequestManagerListener implements PropertyChangeListener {

    private boolean removing;
    private PropertyChangeSupport pcs;

    public TRRequestManagerListener() {
        pcs = new PropertyChangeSupport(this);
    }

    public boolean isRemoving() { return removing; }

    public void propertyChange(PropertyChangeEvent evt) {
        if (evt.getPropertyName().equals("queueSize")) {
            boolean oldRemoving = removing;
            int oldsize = ((Integer)evt.getOldValue()).intValue();
            int newsize = ((Integer)evt.getNewValue()).intValue();

            removing = oldsize > newsize;
            EasyUtil.log("TRReqMgrListener - old size %d, new size %d, " +
                    "removing? %b\n", oldsize, newsize, removing);
            pcs.firePropertyChange("removing", oldRemoving, removing);
        }
    }

    public void addPropertyChangeListener(PropertyChangeListener l) {
        pcs.addPropertyChangeListener(l);
    }

    public void removePropertyChangeListener(PropertyChangeListener l) {
        pcs.removePropertyChangeListener(l);
    }

}
