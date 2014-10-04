<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Chat
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery-1.6.4.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.signalR-1.1.4.js" type="text/javascript"></script>
    <script src='<%: ResolveClientUrl("~/signalr/hubs") %>'></script>
    <style>
        div#divChatMessages
        {
            width: 100vh;
            height: 50vh;
            overflow-x: scroll;
            overflow-y: scroll;
        }
        
        ul#listMessages li
        {
            background-color: white;
            color: black;
            padding: 10px 20px;
            text-decoration: none;
        }
    </style>
    <form id="form1" runat="server" onkeypress="return event.keyCode != 13">
    <script type="text/javascript">
        var IWannaChat;

        String.prototype.format = function () {
            var str = this;
            for (var i = 0; i < arguments.length; i++) {
                var reg = new RegExp("\\{" + i + "\\}", "gm");
                str = str.replace(reg, arguments[i]);
            }
            return str;
        }

        var getDateFormateed = function () {
            var d = new Date();
            var dateString = "{0}/{1}/{2} - {3}:{4}".format(
                            d.getDate().toString(),
                            (d.getMonth() + 1).toString(), //month is 0-11
                            d.getFullYear().toString(),
                            d.getHours(), d.getMinutes())
            return dateString;
        };

        var sendChatMsg = function () {
            message = "{0} ({1}) : {2}".format($('#txtUserName').val(), getDateFormateed, $('#txtMessage').val());

            IWannaChat.server.push(message);

            //Clear the message
            $('#txtMessage').val("");
        
        };

        $(function () {
            //Register to my Chat Hub - SignalR
            IWannaChat = $.connection.EnChatHub;

            //Register to Call Back from Hub
            IWannaChat.client.addMessage = function (message) {
                $('#listMessages').append('<li>' + message + '</li>');

                //Trying to scroll the chat to the bottom
                //$('#listMessages li:first').animate({ top: 0 });
            };

            $("#SendMessage").click(function () {
                sendChatMsg();
            });

            $("#btnClearAll").click(function () {
                $("#listMessages li").remove();
            });

            $('#txtMessage').keypress(function (event) {
                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    sendChatMsg();
                }
            });

            //Initialize/Start SignalR
            $.connection.hub.start();
        });

    </script>
    <div>
        <label for="txtUserName">
            User Name:
        </label>
        <input type="text" id="txtUserName" value="EnPeru" />
        <br />
        <br />
        <label for="txtMessage">
            Enter Chat Message:
        </label>
        <input type="text" id="txtMessage" />
        <input type="button" id="SendMessage" value="  Send  " /> &nbsp;
        <input type="button" id="btnClearAll" value="Clear All" />
        <div id="divChatMessages">
            <fieldset>
                <legend>Messages: </legend>
                <ul id="listMessages" style="list-style-type: none" />
            </fieldset>
        </div>
    </div>
    </form>
</asp:Content>
