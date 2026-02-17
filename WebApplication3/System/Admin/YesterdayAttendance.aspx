<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YesterdayAttendance.aspx.cs" Inherits="WebApplication4.Admin.YesterdayAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Yesterday's Attendance</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .header { background: #007bff; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .container { background: white; padding: 20px; border-radius: 5px; border: 1px solid #ddd; }
        .button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .button:hover { background: #0056b3; }
        .button-secondary { background: #6c757d; }
        .button-secondary:hover { background: #545b62; }
        .message { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; }
        .warning { background: #fff3cd; color: #856404; }
        .error { background: #f8d7da; color: #721c24; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #007bff; color: white; padding: 12px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f5f5f5; }
        .status-attended { color: #28a745; font-weight: bold; }
        .status-absent { color: #dc3545; font-weight: bold; }
        .no-data { text-align: center; padding: 30px; color: #6c757d; font-style: italic; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>📊 Yesterday's Attendance Records</h1>
            <p>View attendance for all employees for <%= DateTime.Now.AddDays(-1).ToString("dddd, MMMM dd, yyyy") %></p>
        </div>
        
        <div class="container">
            <!-- Buttons -->
            <div style="margin-bottom: 20px;">
                <asp:Button ID="btnRefresh" runat="server" Text="🔄 Refresh Data" OnClick="btnRefresh_Click" CssClass="button" />
                <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" OnClick="btnBack_Click" CssClass="button button-secondary" />
            </div>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Statistics -->
            <div style="display: flex; gap: 15px; margin-bottom: 20px;">
                <div style="padding: 15px; background: #e7f3ff; border-radius: 5px; flex: 1;">
                    <h3 style="margin: 0; color: #007bff;">Total Records</h3>
                    <asp:Label ID="lblTotalRecords" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
                <div style="padding: 15px; background: #d4edda; border-radius: 5px; flex: 1;">
                    <h3 style="margin: 0; color: #28a745;">Attended</h3>
                    <asp:Label ID="lblAttended" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
                <div style="padding: 15px; background: #f8d7da; border-radius: 5px; flex: 1;">
                    <h3 style="margin: 0; color: #dc3545;">Absent</h3>
                    <asp:Label ID="lblAbsent" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
            </div>
            
            <!-- Attendance Grid -->
            <div style="overflow-x: auto;">
                <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="false" 
                    CssClass="attendance-table" GridLines="None" ShowHeaderWhenEmpty="true"
                    EmptyDataText="No attendance records found for yesterday">
                    <Columns>
                        <asp:BoundField DataField="attendance_ID" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="emp_ID" HeaderText="Employee ID" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="check_in_time" HeaderText="Check In" DataFormatString="{0:hh\:mm\:ss}" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="check_out_time" HeaderText="Check Out" DataFormatString="{0:hh\:mm\:ss}" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="total_duration" HeaderText="Duration (mins)" ItemStyle-Width="120px" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <span class='<%# Eval("status").ToString().ToLower() == "attended" ? "status-attended" : "status-absent" %>'>
                                    <%# Eval("status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Info" ItemStyle-Width="200px">
                            <ItemTemplate>
                                <asp:Button ID="btnViewEmployee" runat="server" Text="👤 View" 
                                    CommandArgument='<%# Eval("emp_ID") %>' 
                                    OnClick="btnViewEmployee_Click"
                                    CssClass="button" style="padding: 5px 10px; font-size: 12px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#007bff" ForeColor="White" Font-Bold="true" />
                    <RowStyle CssClass="table-row" />
                    <AlternatingRowStyle BackColor="#f9f9f9" />
                    <EmptyDataRowStyle CssClass="no-data" />
                </asp:GridView>
            </div>
            
            <!-- Export Options -->
            <div style="margin-top: 20px; border-top: 1px solid #ddd; padding-top: 20px;">
                <h3>Export Options</h3>
                <asp:Button ID="btnExportExcel" runat="server" Text="📊 Export to Excel" OnClick="btnExportExcel_Click" CssClass="button" />
                <asp:Button ID="btnExportPDF" runat="server" Text="📄 Export to PDF" OnClick="btnExportPDF_Click" CssClass="button" Enabled="false" />
                <asp:Button ID="btnPrint" runat="server" Text="🖨️ Print Report" OnClick="btnPrint_Click" CssClass="button" 
                    OnClientClick="window.print(); return false;" />
            </div>
        </div>
        
        <!-- Hidden Fields -->
        <asp:HiddenField ID="hdnYesterdayDate" runat="server" />
    </form>
</body>
</html>
