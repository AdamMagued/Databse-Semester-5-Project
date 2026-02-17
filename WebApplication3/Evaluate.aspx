 <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Evaluate.aspx.cs" Inherits="WebApplication1.Evaluate" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Evaluation</title>
    <style>
        /* --- 1. CORE ATMOSPHERE --- */
        body {
            background-color: #000;
            background-image: 
                radial-gradient(at 0% 100%, hsla(253,16%,7%,1) 0, transparent 50%), 
                radial-gradient(at 50% 0%, hsla(225,39%,30%,1) 0, transparent 50%);
            min-height: 100vh;
            color: #ffffff;
            font-family: 'Segoe UI', sans-serif;
            margin:0; padding:0;
            overflow-x: hidden;
        }

        .stage-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            width: 100%;
            padding: 40px 0;
        }

        /* --- 2. GLASS PANEL --- */
        .glass-panel {
            width: 100%;
            max-width: 550px;
            background: rgba(18, 18, 18, 0.7);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            padding: 60px 50px;
            box-shadow: 0 40px 90px rgba(0,0,0,0.7);
            position: relative;
        }

        .glass-panel::after {
            content: '';
            position: absolute;
            top: 0; left: 20%; right: 20%;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        }

        .panel-header {
            font-size: 1.4rem;
            color: #fff;
            font-weight: 500;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            letter-spacing: 0.5px;
        }

        .field-wrap { margin-bottom: 30px; }

        .field-label {
            display: block;
            font-size: 0.75rem;
            color: #888;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 600;
        }

        /* --- 3. INPUTS --- */
        .input-line {
            width: 100%;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 1rem;
            padding: 14px 18px;
            border-radius: 10px;
            font-family: 'Segoe UI', sans-serif; /* Clean Font */
            transition: all 0.2s ease-out;
            box-sizing: border-box;
            
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }

        select.input-line {
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
            padding-right: 40px;
        }

        /* Hover & Focus */
        .input-line:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.3);
        }

        .input-line:focus {
            outline: none;
            background: rgba(0, 0, 0, 0.6);
            border-color: #fff;
            box-shadow: 0 0 0 1px #fff;
            transform: translateY(-1px);
        }

        /* Clean Options */
        .input-line option {
            background-color: #111;
            color: #fff;
            padding: 12px;
            font-family: 'Segoe UI', sans-serif;
        }

        /* Score Box */
        .score-box {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            height: 70px;
            background: rgba(255,255,255,0.02);
        }
        .score-box:focus { border-color: #4facfe; box-shadow: 0 0 0 1px #4facfe; }

        /* --- 4. BUTTONS --- */
        .btn-main {
            width: 100%;
            padding: 18px;
            margin-top: 25px;
            background: #fff;
            color: #000;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .btn-main:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(255, 255, 255, 0.25);
            background: #f0f0f0;
        }

        .btn-ghost {
            background: transparent;
            color: #666;
            border: 1px solid #333;
            margin-top: 15px;
        }
        .btn-ghost:hover {
            border-color: #666;
            color: #fff;
            background: transparent;
            box-shadow: none;
        }

        .result-label {
            display: block;
            text-align: center;
            margin-top: 25px;
            font-size: 0.9rem;
            color: #4facfe;
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
        .col-md-5 { flex: 4; }
        .col-md-7 { flex: 8; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="stage-wrapper">
        <div class="glass-panel">
            <div class="panel-header">Performance Review</div>

            <div class="field-wrap">
                <span class="field-label">Select Employee</span>
                <asp:DropDownList ID="ddlEmployees" runat="server" CssClass="input-line">
                </asp:DropDownList>
            </div>

            <div class="row">
                <div class="col-md-5">
                    <div class="field-wrap">
                        <span class="field-label" style="text-align:center">Score (1-10)</span>
                        <asp:TextBox ID="txtScore" runat="server" CssClass="input-line score-box" TextMode="Number" min="1" max="10"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="field-wrap">
                        <span class="field-label">Comments</span>
                        <asp:TextBox ID="txtComment" runat="server" CssClass="input-line" TextMode="MultiLine" Rows="2" style="height: 70px; resize:none;"></asp:TextBox>
                    </div>
                </div>
            </div>

            <asp:Button ID="btnEvaluate" runat="server" Text="Submit Evaluation" OnClick="btnEvaluate_Click" CssClass="btn-main" />

            <asp:Label ID="lblMsg" runat="server" Text="" CssClass="result-label"></asp:Label>
             
            <center>
                <asp:Button ID="btnBack" runat="server" Text="Return to Menu" PostBackUrl="~/MainMenu.aspx" CssClass="btn-main btn-ghost" />
            </center>

            <div class="developer-signature">
                part made by adam magued
            </div>
        </div>
    </div>
    </form>
</body>
</html>