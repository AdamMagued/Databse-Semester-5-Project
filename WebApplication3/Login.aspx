<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication3.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>System Login</title>
    <style>
        body {
            background: #000;
            display: flex; justify-content: center; align-items: center; min-height: 100vh;
            font-family: 'Inter', sans-serif; margin: 0;
        }
        .glass-form {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 20px; padding: 50px;
            width: 100%; max-width: 400px;
            box-shadow: 0 0 100px rgba(255,255,255,0.05);
            position: relative; overflow: hidden;
        }
        .glass-form::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 2px;
            background: linear-gradient(90deg, transparent, #38bdf8, transparent);
        }

        h2 { color: #fff; font-weight: 200; margin-bottom: 40px; text-align: center; letter-spacing: 3px; font-size: 1.5rem; }

        .field { margin-bottom: 30px; }
        label { display: block; color: #64748b; font-size: 0.75rem; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 2px; font-weight: 600; }
        
        .input-glass {
            width: 100%; box-sizing: border-box;
            background: transparent;
            border: 1px solid #333; border-radius: 8px;
            padding: 16px; color: #fff; font-family: inherit; font-size: 1rem;
            transition: 0.3s;
        }
        .input-glass:focus { border-color: #38bdf8; box-shadow: 0 0 30px rgba(56, 189, 248, 0.15); outline: none; background: rgba(56, 189, 248, 0.05); }

        .submit-btn {
            width: 100%; padding: 18px;
            background: #fff; color: #000;
            border: none; border-radius: 8px;
            font-weight: 800; letter-spacing: 1px; cursor: pointer;
            transition: 0.3s; margin-top: 10px;
        }
        .submit-btn:hover { background: #38bdf8; color: #fff; box-shadow: 0 0 40px rgba(56, 189, 248, 0.4); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="glass-form">
            <h2>LOGIN</h2>

            <div class="field">
                <label>Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="input-glass" placeholder="ID Number"></asp:TextBox>
            </div>

            <div class="field">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="input-glass" placeholder="••••••••"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="ACCESS SYSTEM" CssClass="submit-btn" OnClick="btnLogin_Click" />
        </div>
    </form>
</body>
</html>