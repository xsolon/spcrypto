<%@ Page Language="C#" MasterPageFile="~masterurl/default.master" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <SharePoint:ScriptLink Name="sp.js" runat="server" OnDemand="false" LoadAfterUI="true" Localizable="false" />
    <script type="text/javascript" src="/_layouts/15/core.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.core.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
    <script type="text/javascript" src="../scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../Scripts/bootstrap.js"></script>
    <script type="text/javascript" src="../scripts/jsencrypt.min.js"></script>
    <script type="text/javascript" src="../scripts/typedarray.js"></script>
    <script type="text/javascript" src="../scripts/sjcl.js"></script>
    <link rel="Stylesheet" type="text/css" href="../Content/css/bootstrap.min.css" />
    <style type="text/css">
        .row {
            padding-bottom: 15px;
            padding-left: 15px;
        }

        #linkSection {
            padding: 15px;
        }

        .row h3 {
            display: inline;
        }

        .panel-body {
            display: none;
        }

        .xHelp {
            height: 16px;
            width: 16px;
            background: url("/_layouts/15/images/spcommon.png?rev=23") no-repeat -161px -178px;
            display: inline-block;
            vertical-align: top;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Create RSA Keys
</asp:Content>

<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">

    <WebPartPages:WebPartZone Visible="false" runat="server" FrameType="TitleBarOnly" ID="full" Title="loc:full" />
    <br />
    <div class="ms-accessible">
        <div id="step1-Desc">
            <p>This page generates <a href='http://www.ietf.org/rfc/rfc2437.txt'>RSA</a> encryption keys. The keys are used to encrypt/decrypt information in your records.</p>
            <p>You can generate as many as you want. You can also generate these keys using <a href='http://www.openssl.org/'>OpenSSL</a>. For more information check out the <a href=''>OpenSSL RSA tutorial</a>.</p>
            <p>
                The keys can be saved as Shortcuts that you can save in your browser. This lets you keep your keys in your pc, and registerd then when necessary.
            </p>
        </div>
        <div id="keyLength-Desc">
            <br />
            The first step of the process is to choose a key length. The length of an encryption key is a measure of how complex the encryption will be. Some browsers may take a long time to generate 2048 and 4096 bits keys. We recommend Chrome to generate the keys or use  OpenSSL.<br />
            More infor: <a href='http://www.keylength.com/en/compare/'>Cryptographic Key Length recommendation</a>
        </div>
        <br />
        <div id="fields-Desc">
            <p>With the keys set in the public and private fields you can test encrypting/decrypting samples.</p>
        </div>
        <div id="password-Desc">
            <p>As an additional safety measure you can password protect your keys. You will be prompted for your password every time you encrypt/decrypt information.</p>
        </div>
        <div id="save-Desc">
            <p>Once generated you will need to store the keys for further use.</p>
            <p>Method 1: Save in Keys SharePoint list</p>
            <p>This method is very convinient as the keys are stored in the same site. However you are subject to SharePoint permissions. Make sure you configure permissions to secure the keys. It is also important to understand that system administrators can override security settings allowing them to access any file in the site.</p>
            <p>Method 2: Save as a browser Shortcut</p>
            <p>This method stored the keys as shortcuts, the shortcuts are files that can be added to your browser. The advantage here is that the keys never leave your pc and can be shared/copied as files. Relying on your hardware for storage might be a disavantage in the event of hardware failure. Please make sure you backup your keys.</p>
        </div>
    </div>
    <table>
        <tr>
            <td valign="top" style="padding: 10px; width: 150px;">
                <ul class="nav nav-pills nav-stacked">
                    <li><a href="default.aspx">Home</a></li>
                    <li><a href="../Lists/Links">Links</a></li>
                    <li class="active"><a href="SetupRSA.aspx">Key Setup</a></li>
                    <li><a href="../Lists/Keys">Manage Keys</a></li>
                    <li><a href="http://www.xsolon.net/products/spcrypto/privacy.html">Privacy</a></li>
                </ul>
            </td>
            <td>
                <div class="container">
                    <div class="row">
                    </div>
                    <div class="row">
                        <fieldset id="step1">
                            <legend>Generate encryption keys<a class="js-callout-launchPoint" id="step1-Link" href="#step1">
                                <span class="xHelp">&nbsp;</span>
                            </a></legend>
                            <div class="control-group">

                                <label class="control-label" for="bitlength">
                                    Key Length<a class="js-callout-launchPoint" id="keyLength-Link" href="#keyLength">
                                        <span id="ms-pageDescriptionImage">&nbsp;</span>
                                    </a>
                                </label>
                                <div class="controls">
                                    <label class="radio" for="bitlength-0">
                                        <input type="radio" name="bitlength" id="bitlength-0" value="512" checked="checked" required="required" />
                                        512 bits
                                    </label>
                                    <label class="radio" for="bitlength-1">
                                        <input type="radio" name="bitlength" id="bitlength-1" value="1024" required="required" />
                                        1024 bits
                                    </label>
                                    <label class="radio" for="bitlength-2">
                                        <input type="radio" name="bitlength" id="bitlength-2" value="2048" required="required" />
                                        2048 bits
                                    </label>
                                    <label class="radio" for="bitlength-3">
                                        <input type="radio" name="bitlength" id="bitlength-3" value="4096" required="required" />
                                        4096 bits
                                    </label>
                                </div>
                                <div id="warning4096" style="display: block" class="alert alert-warning alert-dismissable">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                    <strong>Warning!</strong> In some browsers 2048 and 4096 bit keys may take too long to calculate; Chrome is recommded or use OpenSSL instead.
                                </div>
                            </div>
                            <button id="generate" class="btn btn-primary">Generate Keys</button>
                            <br />
                            <span><i>
                                <small id="time-report"></small>
                            </i></span>
                        </fieldset>
                    </div>
                    <div class="row">
                        <fieldset id='step2'>
                            <legend>RSA Private/Public Keys<a class="js-callout-launchPoint" id="fields-Link" href="#">
                                <span class="xHelp">&nbsp;</span>
                            </a></legend>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="privkey">Private Key</label><br />
                                    <small>
                                        <textarea id="privkey" rows="15" style="width: 100%">-----INSERT RSA PRIVATE KEY HERE-----</textarea></small>
                                </div>
                                <div class="col-lg-6">
                                    <label for="pubkey">Public Key</label><br />
                                    <small>
                                        <textarea id="pubkey" rows="15" style="width: 100%" readonly="readonly">-----INSERT RSA PUBLIC KEY HERE-----</textarea></small>
                                </div>
                            </div>
                            <div id='passwordDialog1' class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Password protect keys<a class="js-callout-launchPoint" id="password-Link" href="#">
                                        <span class="xHelp">&nbsp;</span>
                                    </a></h3>
                                    <button type="button" class="close"><span class="glyphicon glyphicon-chevron-up"></span></button>
                                </div>
                                <div id='passwordDialog2' class="panel-body" style="display: block">
                                    <p>Optionally, you can password protect your keys.</p>
                                    <p>The password will be required every time you encrypt/decrypt data.</p>

                                    <div class="control-group">
                                        <label class="control-label" for="passwordinput">Password Input</label>
                                        <div class="controls">
                                            <input id="passwordinputA" name="passwordinputA" type="password" placeholder="password here" class="input-xlarge" />
                                        </div>
                                        <label class="control-label" for="passwordinput">Confirm</label>
                                        <div class="controls">
                                            <input id="passwordinputB" name="passwordinputB" type="password" placeholder="password here" class="input-xlarge" />
                                        </div>
                                    </div>
                                    <br />
                                    <button id="btnPasswordProtect" class="btn btn-primary">Encrypt Keys</button>
                                    <span>For your protection, once the keys are encrypted the password fields will be cleared.</span>
                                </div>
                            </div>

                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Test Encryption/Decryption</h3>
                                    <button type="button" class="close"><span class="glyphicon glyphicon-chevron-down"></span></button>
                                </div>
                                <div class="panel-body">
                                    <div class="col-lg-4">
                                        <label for="input">Text to encrypt:</label><br />
                                        <textarea id="input" name="input" style="width: 100%" cols="20" rows="4">This is a test!</textarea>
                                    </div>
                                    <div class="col-lg-4">
                                        <label>&nbsp;</label><br />
                                        <button id="execute" class="btn btn-primary">Encrypt / Decrypt</button>
                                    </div>
                                    <div class="col-lg-4">
                                        <label for="crypted">Encrypted:</label><br />
                                        <textarea id="crypted" name="crypted" style="width: 100%" cols="20" rows="4"></textarea>
                                    </div>
                                </div>
                            </div>

                        </fieldset>
                    </div>
                    <div class="row">
                        <fieldset id="step3">
                            <legend>Save your keys<a class="js-callout-launchPoint" id="save-Link" href="#">
                                <span class="xHelp">&nbsp;</span>
                            </a></legend>
                            <div class="row">
                                <div class="panel panel-default hidden">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Save in Azure Cloud</h3>
                                        <button type="button" class="close"><span class="glyphicon glyphicon-chevron-down"></span></button>
                                    </div>
                                    <div class="panel-body">
                                        <ul>
                                            <li>The keys are stored in an Azure site.</li>
                                            <li>Multiple keys can be managed.</li>
                                            <li>Keys are downloaded throught SSL.</li>
                                            <li>Keys can't be shared with others</li>
                                        </ul>
                                        <button id="btnSaveCloud" class="btn btn-primary">Save in Azure</button>
                                    </div>
                                </div>

                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Save as Shortcuts</h3>
                                        <button type="button" class="close"><span class="glyphicon glyphicon-chevron-down"></span></button>
                                    </div>
                                    <div class="panel-body">
                                        <ul>
                                            <li>The keys are stored as shortcuts in your browser.</li>
                                            <li>Shortcuts can be shared with others as files.</li>
                                        </ul>
                                        <div class="col-lg-4">
                                            <button id="btnGenLinks" class="btn btn-primary">Create Shortcuts</button>
                                            <div id="linkSection"></div>
                                            <div id="info4" style="display: none" class="alert alert-info alert-dismissable">
                                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                                <strong>Info: </strong>Drag the links to your browser's favorites or select 'Add to favorites' from their context menu (right click).
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Save in SharePoint</h3>
                                        <button type="button" class="close"><span class="glyphicon glyphicon-chevron-down"></span></button>
                                    </div>
                                    <div class="panel-body">
                                        <div class="col-lg-4">

                                            <ul>
                                                <li>The keys are stored in SharePoint list.</li>
                                                <li>Multiple keys can be managed.</li>
                                                <li>You can configure security to allow others to use your keys.</li>
                                            </ul>

                                            <!-- Button -->
                                            <div class="control-group">
                                                <label class="control-label" for="btnSaveSP"></label>
                                                <div class="controls">
                                                    <button id="btnSaveSP" name="btnSaveSP" class="btn btn-primary">Save in SharePoint</button>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </div>
                        </fieldset>
                    </div>

                </div>
            </td>
        </tr>
    </table>
    <script type="text/javascript">

        function setUpCallouts() {

            var link1 = document.getElementById("step1-Link");
            SPAnimationUtility.BasicAnimator.FadeIn(link1, null, null);

            var link2 = document.getElementById("keyLength-Link");
            SPAnimationUtility.BasicAnimator.FadeIn(link2, null, null);

            var link3 = document.getElementById("password-Link");
            SPAnimationUtility.BasicAnimator.FadeIn(link3, null, null);

            var link4 = document.getElementById("save-Link");
            SPAnimationUtility.BasicAnimator.FadeIn(link4, null, null);

            var link5 = document.getElementById("fields-Link");
            SPAnimationUtility.BasicAnimator.FadeIn(link5, null, null);


            EnsureScriptFunc("callout.js", "Callout", function () {
                CalloutManager.createNew({ ID: "step1-Callout", launchPoint: link1, openOptions: { event: "click", showCloseButton: true }, content: $('#step1-Desc').html() });

                CalloutManager.createNew({ ID: "keyLength-Callout", launchPoint: link2, openOptions: { event: "click", showCloseButton: true }, content: $('#keyLength-Desc').html() });

                CalloutManager.createNew({ ID: "password-Callout", launchPoint: link3, openOptions: { event: "click", showCloseButton: true }, content: $('#password-Desc').html() });

                CalloutManager.createNew({ ID: "fields-Callout", launchPoint: link5, openOptions: { event: "click", showCloseButton: true }, content: $('#fields-Desc').html() });

                CalloutManager.createNew({ ID: "save-Callout", launchPoint: link4, openOptions: { event: "click", showCloseButton: true }, content: $('#save-Desc').html() });
            });

        };

        $(function () {

            setUpCallouts();

            var bitLength = 512;
            $("input:radio[name=bitlength]").click(function () {
                bitLength = $(this).val();
            });

            $('#btnSaveSP').click(function (event) {

                var options = SP.UI.$create_DialogOptions();

                options.title = "Save Keys";
                options.autoSize = true;
                options.allowMaximize = true;
                options.dialogReturnValueCallback = function (result, val) {
                };

                options.url = L_Menu_BaseUrl + '/Lists/Keys/NewForm.aspx'
                options.args = { priv: $('#privkey').val(), pub: $('#pubkey').val() };
                SP.UI.ModalDialog.showModalDialog(options);
                event.preventDefault();
            });

            $('#btnPasswordProtect').click(function (event) {
                var pswCtrl = $('#passwordinputA');
                if (pswCtrl.val() == '') {
                    alert("Password can't be blank.");
                    pswCtrl.focus();
                    return;
                }
                if (pswCtrl.val() != $('#passwordinputB').val()) {
                    alert("Password do not match.");
                    pswCtrl.focus();
                    return;
                }
                var privKey = $('#privkey');
                var pubKey = $('#pubkey');
                privKey.val(sjcl.encrypt(pswCtrl.val(), privKey.val()));
                pubKey.val(sjcl.encrypt(pswCtrl.val(), pubKey.val()));

                pswCtrl.val(''); $('#passwordinputB').val('');

                event.preventDefault();
            });

            $('button.close').click(function (event) {
                var glyp = $('span', $(this));
                glyp.toggleClass('glyphicon-chevron-down');
                glyp.toggleClass('glyphicon-chevron-up');
                var elem = $('.panel-body', $(this).parents('.panel'));
                if (window.console)
                    console.log(elem.length);
                elem.toggle();
                event.preventDefault();
            });

            $('#btnGenLinks').click(function (event) {

                if (undefined === window.xSolon) window.xSolon = { RSA: {} };

                var privKey = $('#privkey').val().replace(/\n/g, '');
                var pubKey = $('#pubkey').val().replace(/\n/g, '');

                var sec = $('#linkSection');

                var script = 'javascript:xSolon.RSA.privateKey="' + privKey + '";void(0);';

                if (privKey.search(/:/) > 0) {
                    script = "javascript:xSolon.RSA.privateKey=" + privKey + ";void(0);";
                }

                sec.append("<a href='" + script + "'>Register Private Key</a> | ");

                //--
                script = 'javascript:xSolon.RSA.publicKey="' + pubKey + '";void(0);';

                if (pubKey.search(/:/) > 0) {
                    script = "javascript:xSolon.RSA.publicKey=" + pubKey + ";void(0);";
                }

                sec.append("<a href='" + script + "'>Register Public Key</a>");

                //--

                $('#info4').show();

                event.preventDefault();
            });

            // Execute when they click the button.
            $('#execute').click(function (event) {

                // Create the encryption object.
                var crypt = new JSEncrypt();

                var handle = function () {
                    // Set the private.
                    // If no public key is set then set it here...
                    var pubkey = $('#pubkey').val();
                    if (!pubkey) {
                        $('#pubkey').val(crypt.getPublicKey());
                    }

                    // Get the input and crypted values.
                    var input = $('#input').val();
                    var crypted = $('#crypted').val();

                    // Alternate the values.
                    if (input) {
                        $('#crypted').val(crypt.encrypt(input));
                        $('#input').val('');
                    }
                    else if (crypted) {
                        var decrypted = crypt.decrypt(crypted);
                        if (!decrypted)
                            decrypted = 'This is a test!';
                        $('#input').val(decrypted);
                        $('#crypted').val('');
                    }
                };

                var privKey = $('#privkey');

                if (privKey.val().search(/\:/) > -1) {
                    var options = SP.UI.$create_DialogOptions();

                    options.title = "Enter Password";
                    options.autoSize = true;
                    options.allowMaximize = true;
                    options.dialogReturnValueCallback = function onDialogClose(result, val) {
                        if (result == 1) {
                            crypt.setPrivateKey(sjcl.decrypt(val, privKey.val()));
                            handle();
                        }
                    };

                    var tmp = '<div id="passwordDialog4">\
                    <div class="control-group">\
                        <label class="control-label" for="passwordinput">Password Input</label>\
                        <div class="controls">\
                            <input id="passwordinput1" name="passwordinput1" type="password" placeholder="password here" class="input-xlarge" />\
                        </div>\
                    </div><br />\
                    <button onclick="SP.UI.ModalDialog.commonModalDialogClose(1,$(\'#passwordinput1\').val());return false;" class="btn btn-primary">Submit</button>\
                </div>';
                    options.html = $(tmp)[0];
                    options.args = {};
                    SP.UI.ModalDialog.showModalDialog(options);

                } else {
                    crypt.setPrivateKey($('#privkey').val());
                    handle();
                }

                event.preventDefault();
            });

            // If they wish to generate new keys.
            $('#generate').click(function (event) {
                var keySize = parseInt(bitLength);
                crypt = new JSEncrypt({ default_key_size: keySize });
                var dt = new Date();
                var time = -(dt.getTime());
                $('#time-report').text('.');
                var load = setInterval(function () {
                    var text = $('#time-report').text();
                    $('#time-report').text(text + '.');
                    $('.time-report').text(text + '.');
                }, 1000);
                var tmp = "<div><table width='100%' align='center'><tr><td align='center'><img src='/_layouts/images/gears_an.gif'/></td></tr><tr><td></td></tr></table><div class='time-report' /><br /><br /></div>";

                var options = SP.UI.$create_DialogOptions();

                options.title = "Generating Keys";
                options.autoSize = true;
                options.width = 350;
                options.height = 150;
                options.html = $(tmp)[0];
                options.args = {};
                SP.UI.ModalDialog.showModalDialog(options);

                crypt.getKey(function () {
                    clearInterval(load);
                    SP.UI.ModalDialog.commonModalDialogClose(1, '');
                    dt = new Date();
                    time += (dt.getTime());
                    $('#time-report').text('Generated in ' + time + ' ms');
                    $('#privkey').val(crypt.getPrivateKey());
                    $('#pubkey').val(crypt.getPublicKey());
                });
                event.preventDefault();
            });

        });
    </script>

</asp:Content>
