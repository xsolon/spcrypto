(function (ns) {
    "use strict";
    ns.string = {
        htmlEncode: function (value) {

            if (undefined !== STSHtmlEncode)
                return STSHtmlEncode(value);
            // create a in-memory div, set it's inner text(which jQuery
            // automatically encodes)
            // then grab the encoded contents back out. The div never exists on
            // the page.
            return $('<div/>').text(value).html();
        },
        htmlDecode: function htmlDecode(value) {
            if (undefined !== STSHtmlDecode)
                return STSHtmlDecode(value);

            return $('<div/>').html(value).text();
        },
        format: function () {
            var args = arguments;
            var tmpl = args[0];
            for (var i = 0; i < args.length - 1; i++) {
                var s = ('{' + i + '}').replace(/([*+.?|\\\[\]{}()])/g, '\\$1');
                var reg1 = new RegExp(s, 'g');
                tmpl = tmpl.replace(reg1, args[i + 1]);
            }
            return tmpl;
        }, startsWith: function (str1, str2) {
            return str2.length > 0 && str1.substring(0, str2.length) === str2;
        }, endsWith: function (str1, str2) {
            return str2.length > 0 && str1.substring(str1.length - str2.length, str1.length) === str2;
        }
    };
})(window.xSolon = window.xSolon || {});

(function BLL(ns) {

    var w = window;

    if (ns.RSA) return;

    // Constructor
    function RSA() {
        var me = this;

        var editControlType = 'textarea';

        me.registerLocalKey = function (pos, isPrivate) {
            if (isPrivate) {
                me.privateKey = localKeys[pos];
            } else {
                me.publicKey = localKeys[pos];
            }
        }
        var localKeys = [];

        var ui = {
            tmpLocalKeyMenu: '<ie:menuitem type="option" IconSrc="/_layouts/images/{0}" onMenuClick="xSolon.RSA.registerLocalKey({1},{2})" text="{3}" description="{4}"></ie:menuitem>',
            tmpMenu: '<ie:menuitem type="option" IconSrc="{0}" onMenuClick="{1}" text="{2}" description="{3}"></ie:menuitem>',
            tmpMainMenu: '<span style="display: none;">\
<menu id="{0}" largeiconmode="true">{1}</menu></span>\
<div  style="display:inline;float:right">\
    <span>\
        <div nowrap="nowrap" onmouseover="MMU_PopMenuIfShowing(this);MMU_EcbTableMouseOverOut(this, true)" onclick="MMU_Open(byid(\'{0}\'),MMU_GetMenuFromClientId(\'{2}\'),event,false, null, 0);" oncontextmenu="this.click(); return false;" foa="MMU_GetMenuFromClientId(\'{2}\')" hoverinactive="" hoveractive="ms-siteactionsmenuhover">\
            <a class="ms-unselectedtitle" id="{2}" style="white-space: nowrap;" onkeydown="MMU_EcbLinkOnKeyDown(byid(\'{0}\'), MMU_GetMenuFromClientId(\'{2}\'), event);" onclick="MMU_Open(byid(\'{0}\'), MMU_GetMenuFromClientId(\'{2}\'),event,false, null, 0);" onfocus="MMU_EcbLinkOnFocusBlur(byid(\'{0}\'), this, true);" oncontextmenu="this.click(); return false;" href="#" serverclientid="{2}">More...<img align="bottom" src="/_layouts/images/TriDownBlue.GIF" border="0"></a>\
        </div>\
    </span>\
</div>',
            getMenuMarkup: function (fieldName) {

                var menus = [
                    { img: '/_layouts/images/LTOBJECT.GIF', text: 'Create new keys', action: "xSolon.RSA.Options.New();", desc: "Create Public/Private encryption keys" },
                    { img: '/_layouts/images/menudownload.GIF', text: 'Register cloud keys', action: "xSolon.RSA.Options.Cloud();", desc: "Use keys stored in your private cloud." }
                ];

                var allMenu = '';
                for (var i = 0; i < menus.length; i++) {
                    var curMenu = menus[i];
                    allMenu += ns.string.format(ui.tmpMenu, curMenu.img, curMenu.action, curMenu.text, curMenu.desc);
                }

                allMenu += '<ie:menuitem class="xSolkeyMenu" text="Register local keys" type="submenu" description="Use keys from the local keys list." IconSrc="/_layouts/images/securityconfig.gif">\
								<ie:menuitem type="label">\
								</ie:menuitem>\
							</ie:menuitem>';
                var res = ns.string.format(ui.tmpMainMenu, fieldName, allMenu, fieldName + 'Menu')

                return res;
            },
            render: function (ctx, controlType) {
                if (ctx == null || ctx.CurrentFieldValue == null)
                    return '';

                var formCtx = SPClientTemplates.Utility.GetFormContextForCurrentField(ctx);

                if (formCtx == null || formCtx.fieldSchema == null) return '';

                //register callback functions that SharePoint will call at appropriate times
                RegisterCallBacks(formCtx);

                //render the Input controls for the ingredient
                var html = ui.renderForm(formCtx, getValue(ctx) || '', controlType);

                return html;
            },
            renderForm: function (formCtx, curValue, controlType) {
                var tmp = "<div id='section{0}'><{2} id='txt{0}' type='text' name='txt{0}' class='ms-long' rows='6'></{2}></div><a href='#' onclick='xSolon.RSA.Encrypt(\"txt{0}\");'>Encrypt</a> | <a href='#' onclick='xSolon.RSA.Decrypt(\"txt{0}\");'>Decrypt</a> {3}";

                var menu = ui.getMenuMarkup(formCtx.fieldName);

                var res = ns.string.format(tmp, formCtx.fieldName, curValue, controlType, menu);

                var hRes = $('<div><div>' + res + '</div></div>');

                var input = hRes.find('#txt' + formCtx.fieldName);
                if (controlType.search(/input/i) === 0)
                    input.attr('value', curValue);
                else if (controlType.search(/div/i) === 0)
                    input.html(curValue);
                else input.val(curValue);

                res = hRes.html();

                return res;
            }
        };

        var getFieldName = function (ctx) {
            return ctx.CurrentFieldSchema.Name;
        }

        //registers call back functions from SharePoint
        var RegisterCallBacks = function (formCtx) {

            //when the form is initialized, call our anonymous function. 
            formCtx.registerInitCallback(formCtx.fieldName, function () {

                console.log('registerInitCallback' + formCtx.fieldName);

                var context = SP.ClientContext.get_current();
                var web = context.get_web();
                var list = web.get_lists().getByTitle("Keys");

                var viewXml = ns.string.htmlDecode(ns.string.format(ns.string.htmlEncode('<View><Query><Where>{0}</Where><OrderBy><FieldRef Name="Title" /></OrderBy></Query><RowLimit>100</RowLimit></View>'), ''));

                var query = new SP.CamlQuery();

                query.set_viewXml(viewXml);

                var keys = list.getItems(query);

                context.load(keys);
                context.executeQueryAsync(function (sender, args) {
                    var enumer = keys.getEnumerator();
                    var keyMenus = "";

                    localKeys = [];

                    while (enumer.moveNext()) {
                        var li = enumer.get_current();
                        var title = li.get_item('Title');
                        var comm = li.get_item('_Comments');

                        var privateKey = li.get_item('PrivateKey');
                        var publicKey = li.get_item('PublicKey');

                        if (privateKey) {
                            keyMenus += ns.string.format(ui.tmpLocalKeyMenu, 'P1216.GIF', localKeys.length, 'true', title + " - Private", comm);
                            localKeys.push(privateKey);
                        }
                        if (publicKey) {
                            keyMenus += ns.string.format(ui.tmpLocalKeyMenu, 'P7R16.GIF', localKeys.length, 'false', title + " - Public", comm);
                            localKeys.push(publicKey);
                        }
                    }

                    $('.xSolkeyMenu').html(keyMenus);

                }, function (sender, args) {
                    console.log(ns.string.format("{0} {1}", args.get_message(), args.get_stackTrace()));
                });

            });

            //This is where the magic happens! After the user clicks save, call this function. In this function, set the item field value.
            formCtx.registerGetValueCallback(formCtx.fieldName, function () {

                console.log('GetValueCallback' + formCtx.fieldName);

                var val = $('#txt' + formCtx.fieldName).val();

                return val;

            });

            //create container for various validators
            var validators = new SPClientForms.ClientValidation.ValidatorSet();

            //if the field is required, make sure we handle that
            if (formCtx.fieldSchema.Required) {
                //add a required field validator to the collection of validators
                validators.RegisterValidator(new SPClientForms.ClientValidation.RequiredValidator());
            }

            //if we have any validators, register those
            if (validators._registeredValidators.length > 0) {
                formCtx.registerClientValidator(formCtx.fieldName, validators);
            }

            //when there's a validation error, call this function
            formCtx.registerValidationErrorCallback(formCtx.fieldName, function (errorResult) {
                SPFormControl_AppendValidationErrorMessage('section' + formCtx.fieldName, errorResult);
            });
        }

        var getValue = function (ctx) {
            var val = null;

            if (ctx != null && ctx.CurrentItem != null)
                val = ctx.CurrentItem[ctx.CurrentFieldSchema.Name];

            //val = STSHtmlDecode(val);

            //if val begins with <div, we're in display mode so only return what's inside the div
            /*if (val.startsWith('<div dir')) {
                var div = document.createElement('DIV');
                div.innerHTML = val;
    
                val = div.firstChild.innerHTML;
            }
            */
            return val;
        }

        var getEncryption = function (isDecrypt) {
            var def = new $.Deferred();

            if (isDecrypt && undefined === me.privateKey) {
                SP.UI.Notify.addNotification("Error: Private Key is required for decryption.", false);
                def.reject();

            } else {
                var getDialogOpts = function () {
                    var options = SP.UI.$create_DialogOptions();

                    options.title = "Enter Password";
                    options.autoSize = true;
                    options.allowMaximize = true;

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
                    return options;
                };

                var crypt = new JSEncrypt();
                if (undefined !== me.privateKey) {
                    if ('object' === typeof me.privateKey || me.privateKey.search(/:/) > 0) {
                        var opts = getDialogOpts();
                        opts.dialogReturnValueCallback = function (result, val) {
                            if (result == 1) {
                                crypt.setPrivateKey(sjcl.decrypt(val, ('object' === typeof me.privateKey) ? JSON.stringify(me.privateKey) : me.privateKey));
                                def.resolve(crypt);
                            } else {
                                def.reject();
                            }
                        };
                        SP.UI.ModalDialog.showModalDialog(opts);
                    } else {
                        crypt.setPrivateKey(me.privateKey);
                        def.resolve(crypt);
                    }
                } else if (undefined !== me.publicKey) {
                    if ('object' === typeof me.publicKey || me.publicKey.search(/:/) > 0) {
                        var opts = getDialogOpts();
                        opts.dialogReturnValueCallback = function (result, val) {
                            if (result == 1) {
                                crypt.setPublicKey(sjcl.decrypt(val, ('object' === typeof me.publicKey) ? JSON.stringify(me.publicKey) : me.publicKey));
                                def.resolve(crypt);
                            } else {
                                def.reject();
                            }
                        };
                        SP.UI.ModalDialog.showModalDialog(opts);
                    } else {
                        crypt.setPublicKey(me.publicKey);
                        def.resolve(crypt);
                    }
                } else {
                    alert('RSA keys are not registered. Click on the registration shortcut.');
                    crypt = null;
                    def.reject();
                }
            }
            return def.promise();
        };

        //Public ----------------------------

        // SP Render Methods ----------------
        me.View = function (ctx) {
            return "Encrypted field";
        }

        me.Display = function (ctx) {
            return ui.render(ctx, 'div');
        }

        me.Edit = function (ctx, ctrl) {
            return ui.render(ctx, ctrl || editControlType);
        }

        me.New = function (ctx, ctrl) {
            return ui.render(ctx, ctrl || editControlType);
        }

        // ----------------------------------

        var getCtrlVal = function (ctrl) {
            if (ctrl[0].nodeName.search(/div/i) === 0)
                return ctrl.text();
            return ctrl.val();
        };
        var setCtrlVal = function (ctrl, val) {
            if (ctrl[0].nodeName.search(/div/i) === 0)
                ctrl.html(val);
            else ctrl.val(val);
        };

        me.Encrypt = function (id) {
            var ctrl = $('#' + id);

            getEncryption(false).done(function (crypt) {
                if (crypt) {
                    try {
                        var raw = crypt.encrypt(getCtrlVal(ctrl));
                        if (raw !== false)
                            setCtrlVal(ctrl, raw);
                        else { SP.UI.Notify.addNotification("Encryption failed", false); }
                        console.log(raw);

                    } catch (e) {
                        console.log(e);
                    }
                }
            }).fail(function () {
                SP.UI.Notify.addNotification("Failed to create crypto object", false);
            });

            return false;
        }

        me.Decrypt = function (id) {

            var ctrl = $('#' + id);

            getEncryption(true).done(function (crypt) {
                if (crypt) {
                    try {
                        var raw = crypt.decrypt(getCtrlVal(ctrl));
                        if (raw !== false)
                            setCtrlVal(ctrl, raw);
                        else { SP.UI.Notify.addNotification("Decryption failed", false); }
                        console.log(raw);

                    } catch (e) {
                        console.log(e);
                    }
                }
            }).fail(function () {
                SP.UI.Notify.addNotification("Failed to create crypto object", false);
            });

            return false;
        }

        me.Options = {
            New: function () {
                w.location = L_Menu_BaseUrl + '/Pages/SetupRSA.aspx';
            },
            Cloud: function () {
                SP.UI.Notify.addNotification("Available in next version", false);
                alert('Available in next version');
            }
        };

        // --------------------------------------
    }

    ns.RSA = new RSA();

    // Register renderer
    if (typeof SPClientTemplates === 'undefined')
        return;

    var rsaCtx = {};

    rsaCtx.Templates = {};
    //associate the various templates with rendering functions for our field.
    //when a list view is returned to the user, SharePoint will fire the function associate with 'View'.
    //when a list item is in New, SharePoint will fire the function associated with NewForm, etc.
    rsaCtx.Templates.Fields = {
        'RSA_Field1': {
            'View': function (ctx) { return xSolon.RSA.View(ctx); },
            'DisplayForm': function (ctx) { return xSolon.RSA.Display(ctx); },
            'EditForm': function (ctx) { return xSolon.RSA.Edit(ctx); },
            'NewForm': function (ctx) { return xSolon.RSA.New(ctx); }
        },
        'RSA_Field2': {
            'View': function (ctx) { return xSolon.RSA.View(ctx); },
            'DisplayForm': function (ctx) { return xSolon.RSA.Display(ctx); },
            'EditForm': function (ctx) { return xSolon.RSA.Edit(ctx, 'input'); },
            'NewForm': function (ctx) { return xSolon.RSA.New(ctx, 'input'); }
        }
    };

    //register the template to render our field
    SPClientTemplates.TemplateManager.RegisterTemplateOverrides(rsaCtx);

    ExecuteOrDelayUntilScriptLoaded(function () { }, "SP.js")

})(window.xSolon = window.xSolon || {});