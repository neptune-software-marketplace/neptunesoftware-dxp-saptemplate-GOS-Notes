if (sap.n.GOS) {
    oApp.setBusy(true);
    getOnlineSave(sap.n.GOS.TYPEID + "|" + sap.n.GOS.INSTID);
} else {
    jQuery.sap.require("sap.m.MessageToast");
    sap.m.MessageToast.show(txtNoObject);
}
