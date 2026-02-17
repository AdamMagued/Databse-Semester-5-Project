<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompLeaveApproval.aspx.cs" Inherits="WebApplication3.CompLeaveApproval" %>
<!DOCTYPE html>
<html>
<head>
    <title>Compensation Leave Approval</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            padding: 40px;
            width: 100%;
            max-width: 480px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 32px;
        }
        
        .header h1 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .header p {
            color: #718096;
            font-size: 16px;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-group label {
            display: block;
            color: #4a5568;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 6px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 16px;
            color: #2d3748;
            background: #f8fafc;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: white;
        }
        
        .form-control[readonly] {
            background-color: #edf2f7;
            color: #718096;
            cursor: not-allowed;
        }
        
        .select-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 16px;
            color: #2d3748;
            background: #f8fafc;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .select-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: white;
        }
        
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 8px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }
        
        .result-container {
            margin-top: 24px;
            padding: 20px;
            border-radius: 12px;
            display: none;
            animation: fadeIn 0.3s ease;
        }
        
        .result-container.visible {
            display: block;
        }
        
        .result-header {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #2d3748;
        }
        
        .result-status {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        
        .result-reason {
            font-size: 14px;
            color: #718096;
            line-height: 1.5;
        }
        
        .status-approved {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
        }
        
        .status-rejected {
            background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
            color: white;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            color: white;
        }
        
        .status-error {
            background: linear-gradient(135deg, #718096 0%, #4a5568 100%);
            color: white;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 640px) {
            .card {
                padding: 24px;
            }
            
            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form runat="server">
        <div class="card">
            <div class="header">
                <h1>Compensation Leave Approval</h1>
                <p>Process compensation leave requests</p>
            </div>
            
            <div class="form-group">
                <label for="txtRequestID">Request ID</label>
                <asp:TextBox ID="txtRequestID" runat="server" 
                    CssClass="form-control" 
                    placeholder="Enter request ID"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label for="txtHRID">Your HR Employee ID</label>
                <asp:TextBox ID="txtHRID" runat="server" 
                    CssClass="form-control" 
                    ReadOnly="true"></asp:TextBox>
            </div>
            
            <asp:Button ID="btnSubmit" runat="server" 
                Text="Process Request" 
                CssClass="btn-submit" 
                OnClick="btnSubmit_Click" />
            
            <div id="resultContainer" runat="server" class="result-container">
                <div class="result-header">Result</div>
                <div class="result-status">
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                </div>
                <div class="result-reason">
                    <asp:Label ID="lblReason" runat="server"></asp:Label>
                </div>
            </div>
            
            <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>
        </div>
    </form>
</body>
</html>