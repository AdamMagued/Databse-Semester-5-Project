<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SimpleReplaceEmployee.aspx.cs" Inherits="WebApplication4.Admin.SimpleReplaceEmployee" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Replace Employee</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; }
        h1 { color: #007bff; margin-top: 0; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .input-group { margin: 10px 0; }
        label { display: inline-block; width: 150px; font-weight: bold; }
        input[type="text"], input[type="date"] { padding: 8px; width: 200px; border: 1px solid #ddd; border-radius: 4px; }
        .button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .button-success { background: #28a745; }
        .button-success:hover { background: #218838; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .warning { background: #fff3cd; color: #856404; }
        .info { background: #d1ecf1; color: #0c5460; }
        .current-replacements { margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th { background: #007bff; color: white; padding: 10px; text-align: left; }
        td { padding: 8px; border-bottom: 1px solid #ddd; }
        .no-data { text-align: center; padding: 20px; color: #6c757d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>🔄 Replace Employee</h1>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Employee Replacement Form -->
            <div class="section">
                <h3>1. Enter Replacement Details</h3>
                
                <div class="input-group">
                    <label for="txtEmp1ID">Employee to Replace:</label>
                    <asp:TextBox ID="txtEmp1ID" runat="server" placeholder="Employee ID"></asp:TextBox>
                </div>
                
                <div class="input-group">
                    <label for="txtEmp2ID">Replacement Employee:</label>
                    <asp:TextBox ID="txtEmp2ID" runat="server" placeholder="Employee ID"></asp:TextBox>
                </div>
                
                <div class="input-group">
                    <label for="txtFromDate">From Date:</label>
                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>
                </div>
                
                <div class="input-group">
                    <label for="txtToDate">To Date:</label>
                    <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
                </div>
                
                <div style="margin-top: 20px;">
                    <asp:Button ID="btnReplace" runat="server" Text="🔄 Assign Replacement" 
                        OnClick="btnReplace_Click" CssClass="button button-success" />
                </div>
            </div>
            
            <!-- Current Replacements -->
            <div class="section current-replacements">
                <h3>2. Current Replacements</h3>
                <asp:Button ID="btnLoadReplacements" runat="server" Text="🔄 Refresh List" 
                    OnClick="btnLoadReplacements_Click" CssClass="button" />
                
                <asp:GridView ID="gvReplacements" runat="server" AutoGenerateColumns="false" 
                    EmptyDataText="No active replacements found.">
                    <Columns>
                        <asp:BoundField DataField="Emp1_ID" HeaderText="Replaced Employee" />
                        <asp:BoundField DataField="Emp1_Name" HeaderText="Replaced Employee Name" />
                        <asp:BoundField DataField="Emp2_ID" HeaderText="Replacement Employee" />
                        <asp:BoundField DataField="Emp2_Name" HeaderText="Replacement Employee Name" />
                        <asp:BoundField DataField="from_date" HeaderText="From" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="to_date" HeaderText="To" DataFormatString="{0:yyyy-MM-dd}" />
                    </Columns>
                </asp:GridView>
            </div>
            
            <!-- Back Button -->
            <div style="margin-top: 20px;">
                <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" 
                    OnClick="btnBack_Click" CssClass="button" />
            </div>
        </div>
    </form>
    
    <script type="text/javascript">
        // Set default dates
        window.onload = function() {
            var today = new Date();
            var tomorrow = new Date();
            tomorrow.setDate(today.getDate() + 1);
            
            // Format dates as YYYY-MM-DD
            var formatDate = function(date) {
                var year = date.getFullYear();
                var month = String(date.getMonth() + 1).padStart(2, '0');
                var day = String(date.getDate()).padStart(2, '0');
                return year + '-' + month + '-' + day;
            };
            
            // Set default from date (today) and to date (tomorrow)
            document.getElementById('<%= txtFromDate.ClientID %>').value = formatDate(today);
            document.getElementById('<%= txtToDate.ClientID %>').value = formatDate(tomorrow);
        };
    </script>
</body>
</html>
