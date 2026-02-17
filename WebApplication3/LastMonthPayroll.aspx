<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LastMonthPayroll.aspx.cs" Inherits="WebApplication1.LastMonthPayroll" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Financials</title>
    <style>
        body {
            background: radial-gradient(circle at top, #1e1b4b, #000);
            min-height: 100vh; font-family: 'Inter', sans-serif;
            display: flex; justify-content: center; align-items: center; padding: 20px;
        }

        .card {
            background: rgba(255,255,255,0.02);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 40px; width: 100%; max-width: 800px;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        h2 { margin: 0; font-weight: 300; color: #fff; font-size: 1.5rem; }

        .neon-btn {
            background: transparent; color: #6366f1;
            border: 1px solid #6366f1; padding: 10px 25px;
            border-radius: 50px; font-weight: 600; cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.2);
        }
        .neon-btn:hover { background: #6366f1; color: #fff; box-shadow: 0 0 30px rgba(99, 102, 241, 0.6); }

        .data-grid { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .data-grid th { text-align: left; color: #6366f1; font-size: 0.8rem; letter-spacing: 1px; padding: 0 15px; text-transform: uppercase; }
        .data-grid td { background: rgba(0,0,0,0.4); color: #ccc; padding: 20px 15px; }
        .data-grid tr td:first-child { border-radius: 10px 0 0 10px; border-left: 2px solid #6366f1; }
        .data-grid tr td:last-child { border-radius: 0 10px 10px 0; }
    </style>
</head>
<body>
    <form id="form5" runat="server">
        <div class="card">
            <div class="header">
                <h2>Payroll // Previous Cycle</h2>
                <asp:Button ID="btnGetPayroll" runat="server" Text="Refresh Data" OnClick="btnGetPayroll_Click" CssClass="neon-btn" />
            </div>
            <asp:GridView ID="GridViewPayroll" runat="server" AutoGenerateColumns="true" CssClass="data-grid" GridLines="None" Width="100%" />
        </div>
    </form>
</body>
</html>