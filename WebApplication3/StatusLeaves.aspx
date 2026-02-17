<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StatusLeaves.aspx.cs" Inherits="WebApplication1.StatusLeaves" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Status</title>
    <style>
        body {
            background-color: #000; color: #eee;
            font-family: 'Segoe UI', sans-serif;
            padding: 40px; display: flex; justify-content: center;
        }
        .wrapper { width: 100%; max-width: 900px; }
        
        .title-bar { 
            border-left: 4px solid #10b981; 
            padding-left: 20px; margin-bottom: 40px;
        }
        h2 { margin: 0; font-weight: 200; font-size: 2rem; color: #fff; }
        p { margin: 5px 0 0; color: #555; }

        /* Floating Grid */
        .status-grid { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        .status-grid th { text-align: left; padding: 10px 20px; color: #10b981; font-size: 0.85rem; text-transform: uppercase; }
        .status-grid td { 
            background: #111; 
            padding: 20px; 
            border: 1px solid #222;
        }
        .status-grid tr td:first-child { border-radius: 12px 0 0 12px; border-left: 4px solid #333; }
        .status-grid tr td:last-child { border-radius: 0 12px 12px 0; }
        
        .status-grid tr:hover td { border-color: #444; background: #161616; }
        .status-grid tr:hover td:first-child { border-left-color: #10b981; }
    </style>
</head>
<body>
    <form id="form8" runat="server">
        <div class="wrapper">
            <div class="title-bar">
                <h2>My Requests</h2>
                <p>Status tracking for current month</p>
            </div>

            <asp:GridView ID="GridViewStatusLeaves" runat="server" AutoGenerateColumns="true" CssClass="status-grid" GridLines="None" Width="100%" />
        </div>
    </form>
</body>
</html>