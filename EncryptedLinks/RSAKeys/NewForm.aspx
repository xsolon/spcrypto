<%@ Page Language="C#" MasterPageFile="~masterurl/default.master" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage,Microsoft.SharePoint,Version=15.0.0.0,Culture=neutral,PublicKeyToken=71e9bce111e9429c" meta:progid="SharePoint.WebPartPage.Document" %>

<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
    <SharePoint:ListFormPageTitle runat="server" />
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    <asp:ScriptManagerProxy runat="server" ID="ScriptManagerProxy">
    </asp:ScriptManagerProxy>
    <span class="die">
        <SharePoint:ListProperty Property="LinkTitle" runat="server" ID="ID_LinkTitle" />
    </span>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderPageImage" runat="server">
    <img src="/_layouts/15/images/blank.gif?rev=23" width='1' height='1' alt="" />
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <SharePoint:UIVersionedContent UIVersion="4" runat="server">
        <contenttemplate>
	<div style="padding-left:5px">
	</contenttemplate>
    </SharePoint:UIVersionedContent>
    <table class="ms-core-tableNoSpace" id="onetIDListForm">
        <tr>
            <td>
	 <WebPartPages:WebPartZone runat="server" FrameType="None" ID="Main" Title="loc:Main">
         <ZoneTemplate></ZoneTemplate>
     </WebPartPages:WebPartZone>                               
            </td>
        </tr>
    </table>
    <SharePoint:UIVersionedContent UIVersion="4" runat="server">
        <contenttemplate>
	</div>
	</contenttemplate>
    </SharePoint:UIVersionedContent>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <script type="text/javascript" src="../../_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="../../_layouts/15/sp.js"></script>
    <script type="text/javascript" src="../../scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            try {
                var args = window.frameElement.dialogArgs;

                var map = xSolon.getFieldMap();

                $('textarea', map['PrivateKey']).val(args.priv);
                $('textarea', map['PublicKey']).val(args.pub);

            } catch (ignore) {
             
            }
        });

        (function (ns) {
            "use strict";
            ns.getFieldMap = function () {
                var res = {};
                $("td.ms-formbody").each(function () {
                    var html = $(this).html().replace(/\n/g, '');
                    if (html.indexOf('FieldInternalName="') < 0) return;
                    var start = html.indexOf('FieldInternalName="') + 'FieldInternalName="'.length;
                    html = html.substring(start);
                    var stopp = html.indexOf('"');
                    var nm = html.substring(0, stopp);
                    res[nm] = this.parentNode;
                });
                return res;
            };
        })(window.xSolon = window.xSolon || {});
    </script>
    <SharePoint:DelegateControl runat="server" ControlId="FormCustomRedirectControl" AllowMultipleControls="true" />
    <SharePoint:UIVersionedContent UIVersion="4" runat="server">
        <contenttemplate>
		<SharePoint:CssRegistration Name="forms.css" runat="server"/>
	</contenttemplate>
    </SharePoint:UIVersionedContent>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderTitleLeftBorder" runat="server">
    <table cellpadding="0" height="100%" width="100%" cellspacing="0">
        <tr>
            <td class="ms-areaseparatorleft">
                <img src="/_layouts/15/images/blank.gif?rev=23" width='1' height='1' alt="" /></td>
        </tr>
    </table>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderTitleAreaClass" runat="server">
    <script type="text/javascript" id="onetidPageTitleAreaFrameScript">
        if (document.getElementById("onetidPageTitleAreaFrame") != null) {
            document.getElementById("onetidPageTitleAreaFrame").className = "ms-areaseparator";
        }
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderBodyAreaClass" runat="server">
    <SharePoint:StyleBlock runat="server">
        .ms-bodyareaframe {
	padding: 8px;
	border: none;
}
    </SharePoint:StyleBlock>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderBodyLeftBorder" runat="server">
    <div class='ms-areaseparatorleft'>
        <img src="/_layouts/15/images/blank.gif?rev=23" width='8' height='100%' alt="" /></div>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderTitleRightMargin" runat="server">
    <div class='ms-areaseparatorright'>
        <img src="/_layouts/15/images/blank.gif?rev=23" width='8' height='100%' alt="" /></div>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderBodyRightMargin" runat="server">
    <div class='ms-areaseparatorright'>
        <img src="/_layouts/15/images/blank.gif?rev=23" width='8' height='100%' alt="" /></div>
</asp:Content>
<asp:Content ContentPlaceHolderID="PlaceHolderTitleAreaSeparator" runat="server" />
