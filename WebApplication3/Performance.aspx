<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Performance.aspx.cs" Inherits="WebApplication1.EmployeePerformance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Performance Matrix</title>
    <style>
        body {
            background: #000;
            background-image: linear-gradient(45deg, #0f0f0f 25%, transparent 25%, transparent 75%, #0f0f0f 75%, #0f0f0f), 
                              linear-gradient(45deg, #0f0f0f 25%, transparent 25%, transparent 75%, #0f0f0f 75%, #0f0f0f);
            background-size: 60px 60px;
            background-position: 0 0, 30px 30px;
            font-family: 'Segoe UI', sans-serif;
            color: #fff; display: flex; justify-content: center; padding-top: 50px;
        }

        .container {
            width: 100%; max-width: 900px;
            background: rgba(10, 10, 10, 0.8);
            border: 1px solid #222;
            box-shadow: 0 0 50px rgba(0,0,0,0.8);
            border-radius: 20px; padding: 40px;
        }

        h2 { font-weight: 300; letter-spacing: 2px; text-transform: uppercase; color: #888; border-bottom: 1px solid #222; padding-bottom: 20px; margin-bottom: 30px; }

        .control-bar { display: flex; gap: 15px; margin-bottom: 40px; }
        
        .glow-input {
            flex-grow: 1;
            background: #000;
            border: 1px solid #333;
            color: #fff; padding: 15px 20px;
            border-radius: 12px; font-size: 1rem;
            transition: 0.3s; outline: none;
        }
        .glow-input:focus { border-color: #06b6d4; box-shadow: 0 0 15px rgba(6, 182, 212, 0.4); }

        .glow-btn {
            background: #06b6d4; color: #000;
            border: none; padding: 0 30px;
            font-weight: 700; text-transform: uppercase;
            border-radius: 12px; cursor: pointer;
            transition: 0.3s;
        }
        .glow-btn:hover { background: #fff; box-shadow: 0 0 20px #fff; }

        /* Obsidian Table Styles */
        .obsidian-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .obsidian-table th { text-align: left; color: #555; font-size: 0.8rem; text-transform: uppercase; padding: 10px 20px; letter-spacing: 1px; }
        .obsidian-table td { background: rgba(255,255,255,0.03); padding: 20px; border-top: 1px solid rgba(255,255,255,0.05); }
        .obsidian-table tr td:first-child { border-radius: 10px 0 0 10px; border-left: 1px solid rgba(255,255,255,0.05); }
        .obsidian-table tr td:last-child { border-radius: 0 10px 10px 0; border-right: 1px solid rgba(255,255,255,0.05); }
        .obsidian-table tr:hover td { background: rgba(255,255,255,0.06); transform: scale(1.01); transition: 0.2s; }

        .error-msg { color: #ef4444; font-size: 0.9rem; margin-top: 10px; display: block; text-align: center; }
    </style>
</head>
<body>
    <form id="form2" runat="server">
         <div class="container">
            <h2>Matrix / Performance</h2>
            
            <div class="control-bar">
                <asp:TextBox ID="SemesterTextBox" runat="server" CssClass="glow-input" placeholder="Enter Semester (e.g. W24)"></asp:TextBox>
                <asp:Button ID="RetrieveButton" runat="server" Text="Execute" OnClick="RetrieveButton_Click" CssClass="glow-btn" />
            </div>

            <asp:GridView ID="PerformanceGridView" runat="server" AutoGenerateColumns="true" CssClass="obsidian-table" GridLines="None"></asp:GridView>
            
            <asp:Label ID="MessageLabel" runat="server" CssClass="error-msg"></asp:Label>
        </div>
    </form>
</body>
</html>