using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace all_pass.Hubs
{
    [HubName("EnChatHub")]
    public class ChatHub : Hub 
    {
        public void push(string message)
        {
            Clients.All.addMessage(message);
        }
    }
}