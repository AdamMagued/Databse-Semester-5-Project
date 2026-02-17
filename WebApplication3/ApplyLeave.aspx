<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApplyLeave.aspx.cs" Inherits="WebApplication1.ApplyLeave" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Apply for Leave</title>
    <style>
        /* --- 1. ATMOSPHERE --- */
        body {
            background-color: #050505;
            background-image: 
                radial-gradient(circle at 15% 50%, rgba(79, 172, 254, 0.05) 0%, transparent 45%), 
                radial-gradient(circle at 85% 30%, rgba(162, 59, 255, 0.05) 0%, transparent 45%);
            color: #fff;
            font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', sans-serif; /* Clean Font */
            margin: 0; padding: 0;
            overflow-x: hidden;
        }

        .page-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            width: 100%;
            padding: 40px 0;
        }

        /* --- 2. GLASS CARD --- */
        .glass-card {
            width: 100%;
            max-width: 650px;
            background: rgba(20, 20, 20, 0.6);
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            padding: 50px;
            box-shadow: 0 40px 80px rgba(0,0,0,0.6);
            position: relative;
        }

        .form-title {
            font-size: 1.75rem;
            font-weight: 600;
            background: linear-gradient(90deg, #fff, #a1c4fd);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 40px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 20px;
            letter-spacing: -0.5px;
        }

        .input-group { margin-bottom: 25px; }

        .form-label {
            display: block;
            font-size: 0.75rem;
            color: rgba(255, 255, 255, 0.5);
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 700;
        }

        /* --- 3. PROFESSIONAL INPUTS --- */
        .dark-input {
            width: 100%;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff;
            padding: 16px 20px;
            border-radius: 12px;
            font-size: 1rem;
            font-family: 'Segoe UI', sans-serif; /* Standard Font */
            box-sizing: border-box;
            transition: all 0.2s ease-out;
            
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }

        /* Hover Effect: Subtle Highlight */
        .dark-input:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.4);
        }

        /* Focus Effect: Sharp Blue Border, No blurry glow */
        .dark-input:focus {
            outline: none;
            background: rgba(0, 0, 0, 0.6); 
            border-color: #4facfe;
            box-shadow: 0 0 0 1px #4facfe; /* Sharp precision ring */
            transform: translateY(-1px);
        }

        /* --- 4. DROPDOWN STYLING --- */
        select.dark-input {
            cursor: pointer;
            /* Minimalist Chevron Arrow */
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
            padding-right: 45px;
        }

        /* CLEAN OPTIONS - No Code Font, Just Dark Theme */
        select.dark-input option {
            background-color: #111;
            color: #fff;
            padding: 15px;
            font-size: 1rem;
            font-family: 'Segoe UI', sans-serif;
        }

        /* --- 5. PANELS --- */
        .slide-panel {
            background: linear-gradient(145deg, rgba(79, 172, 254, 0.05), rgba(0,0,0,0));
            border-left: 2px solid #4facfe;
            border-radius: 0 12px 12px 0;
            padding: 25px;
            margin-top: 25px;
            animation: fadeIn 0.4s ease-out;
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* --- 6. BUTTONS --- */
        .btn-submit {
            width: 100%;
            padding: 18px;
            margin-top: 35px;
            background: #fff;
            color: #000;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            background: #4facfe;
            color: white;
            box-shadow: 0 10px 30px rgba(79, 172, 254, 0.3);
            transform: translateY(-2px);
        }

        .btn-ghost {
            background: transparent;
            color: rgba(255,255,255,0.5);
            border: 1px solid rgba(255,255,255,0.1);
            margin-top: 15px;
        }
        .btn-ghost:hover {
            border-color: #fff;
            color: #fff;
            background: transparent;
            box-shadow: none;
        }

        .feedback-label {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .developer-signature {
            text-align: center;
            margin-top: 50px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 10px;
            color: rgba(255, 255, 255, 0.2);
            letter-spacing: 3px;
            text-transform: lowercase;
            pointer-events: none;
        }

        .row { display: flex; gap: 20px; }
        .col-md-6 { flex: 1; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="page-wrapper">
        <div class="glass-card">
            
            <h2 class="form-title">New Application</h2>

            <div class="input-group">
                <span class="form-label">Leave Category</span>
                <asp:DropDownList ID="ddlLeaveType" runat="server" CssClass="dark-input" AutoPostBack="true" OnSelectedIndexChanged="ddlLeaveType_SelectedIndexChanged">
                    <asp:ListItem Value="accidental">Accidental Leave</asp:ListItem>
                    <asp:ListItem Value="medical">Medical Leave</asp:ListItem>
                    <asp:ListItem Value="unpaid">Unpaid Leave</asp:ListItem>
                    <asp:ListItem Value="compensation">Compensation Leave</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="form-label">Start Date</span>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="dark-input"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="form-label">End Date</span>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="dark-input"></asp:TextBox>
                    </div>
                </div>
            </div>

            <asp:Panel ID="pnlReplacement" runat="server" Visible="false" CssClass="slide-panel">
                <div class="input-group" style="margin-bottom:0">
                    <span class="form-label" style="color:#4facfe">Replacement Employee ID</span>
                    <asp:TextBox ID="txtReplacement" runat="server" CssClass="dark-input" placeholder="e.g. 42"></asp:TextBox>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlCompensation" runat="server" Visible="false" CssClass="slide-panel">
                <div class="input-group">
                    <span class="form-label" style="color:#4facfe">Original Work Date</span>
                    <asp:TextBox ID="txtOriginalDate" runat="server" TextMode="Date" CssClass="dark-input"></asp:TextBox>
                </div>
                <div class="input-group" style="margin-bottom:0">
                    <span class="form-label" style="color:#4facfe">Reason for Request</span>
                    <asp:TextBox ID="txtReason" runat="server" CssClass="dark-input" placeholder="Brief justification..."></asp:TextBox>
                </div>
            </asp:Panel>

            <asp:Button ID="btnApply" runat="server" Text="Submit Request" OnClick="btnApply_Click" CssClass="btn-submit" />
            
            <asp:Label ID="lblMessage" runat="server" Text="" CssClass="feedback-label"></asp:Label>

            <center>
                <asp:Button ID="btnBack" runat="server" Text="Return to Menu" PostBackUrl="~/MainMenu.aspx" CssClass="btn-submit btn-ghost" />
            </center>

            <div class="developer-signature">
                part made by adam magued
            </div>

        </div>
    </div>
    </form>
</body>
</html>