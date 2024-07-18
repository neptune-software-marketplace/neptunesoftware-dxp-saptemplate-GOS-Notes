oApp.setBusy(false);

if (typeof modelsysMessage.oData === 'undefined') {

    // perform Callback
    if (sap.n.GOS.callBack) {
        sap.n.GOS.callBack();
    }

    // Close Dialog
    butCancel.firePress();

} else {
    diaMessage.open();
}
