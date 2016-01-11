(function tryThis() {

    if ($('a[clipboard]').size() < 2) {
        window.requestAnimationFrame(tryThis);
    } else {

        var clipboard = new Clipboard('[clipboard]', {
            text: function (trigger) {
                xSolon.RSA.Decrypt(trigger.getAttribute("field"), true);
                return trigger.getAttribute("val");
            }
        });

        clipboard.on('success', function (e) {
            e.clearSelection();

            console.info('Action:', e.action);
            console.info('Text:', e.text);
            console.info('Trigger:', e.trigger);
            SP.UI.Notify.addNotification("Copied to Clipboard!", false);
            //showTooltip(e.trigger, 'Copied!');
        });

        clipboard.on('error', function (e) {
            console.error('Action:', e.action);
            console.error('Trigger:', e.trigger);

            SP.UI.Notify.addNotification("Failed to copy.", false);
            //showTooltip(e.trigger, fallbackMessage(e.action));
        });
    }
})();