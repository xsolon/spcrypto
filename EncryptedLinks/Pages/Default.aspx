<%-- The following 4 lines are ASP.NET directives needed when using SharePoint components --%>

<%@ Page Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" MasterPageFile="~masterurl/default.master" Language="C#" %>

<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%-- The markup and script in the following Content element will be placed in the <head> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <SharePoint:ScriptLink Name="sp.js" runat="server" OnDemand="false" LoadAfterUI="true" Localizable="false" />
    <script type="text/javascript" src="../Scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../Scripts/bootstrap.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
    <meta name="WebPartPageExpansion" content="full" />
    <!-- Add your CSS styles to the following file -->
    <link rel="Stylesheet" type="text/css" href="../Content/css/bootstrap.min.css" />

</asp:Content>

<%-- The markup in the following Content element will be placed in the TitleArea of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Encrypted List
</asp:Content>

<%-- The markup and script in the following Content element will be placed in the <body> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <br />
    <table>
        <tr>
            <td valign="top" style="padding:10px;width:150px;">
                <ul class="nav nav-pills nav-stacked">
                    <li class="active"><a href="default.aspx">Home</a></li>
                    <li><a href="../Lists/Links">Links</a></li>
                    <li><a href="SetupRSA.aspx">Key Setup</a></li>
                    <li><a href="../Lists/Keys">Manage Keys</a></li>
                    <li><a href="http://www.xsolon.net/products/spcrypto/privacy.html">Privacy</a></li>
                </ul>
            </td>
            <td>
                <WebPartPages:WebPartZone runat="server" FrameType="None" ID="WebPartZone">
                <WebPartPages:XsltListViewWebPart runat="server"
                    ListUrl="Lists/MenuList">
                </WebPartPages:XsltListViewWebPart>
            </WebPartPages:WebPartZone>
                
                <WebPartPages:WebPartZone runat="server" FrameType="None" ID="Main" Title="loc:Main">
                    <ZoneTemplate></ZoneTemplate>
                </WebPartPages:WebPartZone>

                <style type="text/css">
                    .ms-promlink-body{
                        width:100%;
                    }
                </style>
            </td>
        </tr>
    </table>
    <div>
        Developed by <a href='http://www.xsolon.net'>xSolon</a> | Some icons by <a href="http://modernuiicons.com/">ModernUI Icons</a>
    </div>
</asp:Content>
