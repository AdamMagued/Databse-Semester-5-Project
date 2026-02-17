<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainMenu.aspx.cs" Inherits="WebApplication1.MainMenu" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Command Center</title>
    <style>
        /* OBSIDIAN THEME CORE */
        body {
            margin: 0; padding: 0;
            background-color: #050505;
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(76, 29, 149, 0.15) 0%, transparent 40%),
                radial-gradient(circle at 90% 80%, rgba(37, 99, 235, 0.1) 0%, transparent 40%);
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            color: #ffffff;
            min-height: 100vh;
            display: flex; justify-content: center; align-items: center;
        }

        .glass-dashboard {
            width: 100%; max-width: 1000px;
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 32px;
            padding: 50px;
            box-shadow: 0 40px 80px rgba(0, 0, 0, 0.5);
        }

        h2 {
            font-size: 2rem; font-weight: 200; letter-spacing: 2px;
            text-align: center; margin-bottom: 40px;
            background: linear-gradient(to right, #fff, #94a3b8);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        .grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
        }

        .tile-btn {
            appearance: none; border: none;
            background: rgba(255, 255, 255, 0.03);
            color: #e2e8f0;
            font-size: 0.95rem; font-weight: 500; letter-spacing: 0.5px;
            padding: 25px;
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: flex; align-items: center; justify-content: center;
            height: 120px; text-transform: uppercase;
        }

        .tile-btn:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(139, 92, 246, 0.5);
            box-shadow: 0 0 30px rgba(139, 92, 246, 0.2);
            transform: translateY(-5px) scale(1.02);
            color: #fff;
        }

        .tile-primary { border-top: 2px solid #8b5cf6; } /* Purple Accent */
        .tile-secondary { border-top: 2px solid #06b6d4; } /* Cyan Accent */

        .logout-container { margin-top: 40px; text-align: center; }
        .btn-logout {
            background: transparent; color: #64748b;
            border: 1px solid #334155; padding: 10px 30px;
            border-radius: 50px; cursor: pointer; transition: 0.3s;
            font-size: 0.8rem; letter-spacing: 1px; text-transform: uppercase;
        }
        .btn-logout:hover { color: #fff; border-color: #fff; background: rgba(255,255,255,0.05); }
    </style>
</head>
<body>
    <form id="form3" runat="server">
        <div class="glass-dashboard">
            <h2>Welcome, Employee</h2>
            
            <div class="grid">
                <asp:Button ID="btnPerformance" runat="server" Text="My Performance" CssClass="tile-btn tile-primary" OnClick="btnPerformance_Click" />
                <asp:Button ID="btnAttendance" runat="server" Text="Attendance Log" CssClass="tile-btn tile-primary" OnClick="btnAttendance_Click" />
                <asp:Button ID="btnPayroll" runat="server" Text="Payroll History" CssClass="tile-btn tile-primary" OnClick="btnPayroll_Click" />
                <asp:Button ID="btnDeductions" runat="server" Text="Deductions" CssClass="tile-btn tile-primary" OnClick="btnDeductions_Click" />
                
                <asp:Button ID="btnApplyAnnualLeave" runat="server" Text="Apply Annual Leave" CssClass="tile-btn tile-secondary" OnClick="btnApplyAnnualLeave_Click" />
                <asp:Button ID="btnLeaveStatus" runat="server" Text="Request Status" CssClass="tile-btn tile-secondary" OnClick="btnLeaveStatus_Click" />
                <asp:Button ID="btnApplyLeave" runat="server" Text="Apply Other Leave" CssClass="tile-btn tile-secondary" OnClick="btnApplyLeave_Click" />
                <asp:Button ID="btnViewLeaves" runat="server" Text="View All Leaves" CssClass="tile-btn tile-secondary" OnClick="btnViewLeaves_Click" />
                <asp:Button ID="btnEvaluate" runat="server" Text="Evaluate Peer" CssClass="tile-btn tile-secondary" OnClick="btnEvaluate_Click" />
            </div>

            <div class="logout-container">
                <asp:Button ID="btnLogout" runat="server" Text="Disconnect" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>
    </form>
</body>
</html>