<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Attendance.aspx.cs" Inherits="WebApplication1.Attendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Log</title>
    <style>
        body {
            background-color: #000;
            color: #ccc;
            font-family: 'Roboto Mono', monospace; /* Tech feel */
            display: flex; justify-content: center; padding: 40px;
        }

        .terminal-window {
            width: 100%; max-width: 800px;
            border: 1px solid #333;
            border-radius: 8px;
            padding: 20px;
            background: rgba(10,10,10,0.95);
            box-shadow: 0 0 40px rgba(0,255,0,0.05);
        }

        h2 { color: #0f0; text-shadow: 0 0 10px #0f0; margin-top: 0; font-size: 1.2rem; margin-bottom: 20px; }
        h2::before { content: "> "; }

        .terminal-table { width: 100%; border-collapse: collapse; }
        .terminal-table th { text-align: left; border-bottom: 1px solid #333; color: #0f0; padding: 10px; font-size: 0.9rem; }
        .terminal-table td { padding: 12px 10px; border-bottom: 1px solid #111; color: #fff; font-size: 0.9rem; }
        .terminal-table tr:hover td { background: #111; color: #0f0; }
    </style>
</head>
<body>
    <form id="form4" runat="server">
        <div class="terminal-window">
            <h2>System.Log.Attendance(CurrentMonth)</h2>
            <asp:GridView ID="GridViewAttendance" runat="server" AutoGenerateColumns="true" CssClass="terminal-table" GridLines="None" Width="100%" />
        </div>
    </form>
</body>
</html>