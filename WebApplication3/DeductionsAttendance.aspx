<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeductionsAttendance.aspx.cs" Inherits="WebApplication1.DeductionsAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Deductions</title>
    <style>
        body {
            background-color: #0a0a0a;
            color: white; font-family: 'Segoe UI', sans-serif;
            display: flex; justify-content: center; padding-top: 60px;
        }
        .interface {
            width: 100%; max-width: 700px;
        }
        h2 { font-weight: 800; font-size: 3rem; margin: 0; color: #1a1a1a; text-transform: uppercase; line-height: 0.8; letter-spacing: -2px; }
        h2 span { color: #ef4444; }

        .input-group {
            display: flex; gap: 0; margin: 40px 0;
            background: #111; border: 1px solid #333; border-radius: 12px;
            overflow: hidden; padding: 5px;
        }
        .dark-input {
            flex-grow: 1; background: transparent; border: none;
            color: white; padding: 15px; font-size: 1.1rem; outline: none;
        }
        .action-btn {
            background: #ef4444; color: white; border: none;
            padding: 0 30px; border-radius: 8px; font-weight: bold; cursor: pointer;
            transition: 0.2s;
        }
        .action-btn:hover { background: #dc2626; }

        .table-d { width: 100%; border-top: 1px solid #333; }
        .table-d th { text-align: left; color: #666; padding: 15px 0; font-weight: 400; }
        .table-d td { padding: 15px 0; border-bottom: 1px solid #222; color: #aaa; }
    </style>
</head>
<body>
    <form id="form6" runat="server">
        <div class="interface">
            <h2>Attendance<br /><span>Deductions</span></h2>
            
            <div class="input-group">
                <asp:TextBox ID="txtMonth" runat="server" CssClass="dark-input" placeholder="Enter Month ID (1-12)"></asp:TextBox>
                <asp:Button ID="btnFetch" runat="server" Text="SCAN" OnClick="btnFetch_Click" CssClass="action-btn" />
            </div>

            <asp:GridView ID="GridViewDeductions" runat="server" AutoGenerateColumns="true" CssClass="table-d" GridLines="None" Width="100%" />
        </div>
    </form>
</body>
</html>