<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApplyAnnualLeave.aspx.cs" Inherits="WebApplication1.ApplyAnnualLeave" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Annual Leave</title>
    <style>
        body {
            background: #000;
            display: flex; justify-content: center; align-items: center; min-height: 100vh;
            font-family: 'Inter', sans-serif;
        }
        .glass-form {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px; padding: 50px;
            width: 100%; max-width: 500px;
            box-shadow: 0 0 100px rgba(255,255,255,0.05);
            position: relative; overflow: hidden;
        }
        /* Top accent line */
        .glass-form::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 2px;
            background: linear-gradient(90deg, transparent, #0ea5e9, transparent);
        }

        h2 { color: #fff; font-weight: 300; margin-bottom: 30px; text-align: center; letter-spacing: 1px; }

        .field { margin-bottom: 25px; }
        label { display: block; color: #888; font-size: 0.8rem; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 1px; }
        
        .input-glass {
            width: 100%; box-sizing: border-box;
            background: transparent;
            border: 1px solid #444; border-radius: 8px;
            padding: 15px; color: #fff; font-family: inherit;
            transition: 0.3s;
        }
        .input-glass:focus { border-color: #0ea5e9; box-shadow: 0 0 20px rgba(14, 165, 233, 0.2); outline: none; background: rgba(14, 165, 233, 0.05); }

        .submit-btn {
            width: 100%; padding: 18px;
            background: #fff; color: #000;
            border: none; border-radius: 8px;
            font-weight: 800; letter-spacing: 1px; cursor: pointer;
            transition: 0.3s; margin-top: 10px;
        }
        .submit-btn:hover { background: #0ea5e9; color: #fff; box-shadow: 0 0 40px rgba(14, 165, 233, 0.4); }

        .msg { display: block; text-align: center; margin-top: 20px; font-size: 0.9rem; color: #f43f5e; }
    </style>
</head>
<body>
    <form id="form7" runat="server">
        <div class="glass-form">
            <h2>ANNUAL LEAVE</h2>

            <div class="field">
                <label>Replacement ID</label>
                <asp:TextBox ID="txtReplacement" runat="server" CssClass="input-glass" placeholder="ID Number"></asp:TextBox>
            </div>

            <div class="field">
                <label>Start</label>
                <asp:TextBox ID="txtStartDate" TextMode="Date" runat="server" CssClass="input-glass"></asp:TextBox>
            </div>

            <div class="field">
                <label>End</label>
                <asp:TextBox ID="txtEndDate" TextMode="Date" runat="server" CssClass="input-glass"></asp:TextBox>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="SUBMIT REQUEST" CssClass="submit-btn" OnClick="btnSubmit_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>
        </div>
    </form>
</body>
</html>