<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WinterPerformance.aspx.cs" Inherits="WebApplication4.Admin.WinterPerformance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Winter Performance</title>
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
        .filters { background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .filter-group { display: inline-block; margin-right: 15px; }
        .filter-label { font-weight: bold; margin-right: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #007bff; color: white; padding: 12px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f5f5f5; }
        .rating-5 { color: #28a745; font-weight: bold; }
        .rating-4 { color: #20c997; font-weight: bold; }
        .rating-3 { color: #ffc107; font-weight: bold; }
        .rating-2 { color: #fd7e14; font-weight: bold; }
        .rating-1 { color: #dc3545; font-weight: bold; }
        .rating-star { font-size: 18px; }
        .no-data { text-align: center; padding: 30px; color: #6c757d; font-style: italic; }
        .stat-box { padding: 15px; border-radius: 5px; margin-bottom: 10px; }
        .stats-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>❄️ Winter Semester Performance</h1>
            <p>View performance evaluations for all employees in Winter semesters</p>
        </div>
        
        <div class="container">
            <!-- Buttons -->
            <div style="margin-bottom: 20px;">
                <asp:Button ID="btnRefresh" runat="server" Text="🔄 Refresh Data" OnClick="btnRefresh_Click" CssClass="button" />
                <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" OnClick="btnBack_Click" CssClass="button button-secondary" />
            </div>
            
            <!-- Filters -->
            <div class="filters">
                <h3 style="margin-top: 0;">Filter Results</h3>
                <div class="filter-group">
                    <span class="filter-label">Semester:</span>
                    <asp:DropDownList ID="ddlSemester" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSemester_SelectedIndexChanged">
                        <asp:ListItem Text="All Winter Semesters" Value=""></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <span class="filter-label">Department:</span>
                    <asp:DropDownList ID="ddlDepartment" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                        <asp:ListItem Text="All Departments" Value=""></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <span class="filter-label">Min Rating:</span>
                    <asp:DropDownList ID="ddlMinRating" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlMinRating_SelectedIndexChanged">
                        <asp:ListItem Text="Any" Value="0"></asp:ListItem>
                        <asp:ListItem Text="3+ Stars" Value="3"></asp:ListItem>
                        <asp:ListItem Text="4+ Stars" Value="4"></asp:ListItem>
                        <asp:ListItem Text="5 Stars" Value="5"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" OnClick="btnClearFilters_Click" CssClass="button button-secondary" />
                </div>
            </div>
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
            
            <!-- Statistics -->
            <div class="stats-container">
                <div class="stat-box" style="background: #e7f3ff;">
                    <h3 style="margin: 0; color: #007bff;">Total Records</h3>
                    <asp:Label ID="lblTotalRecords" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
                <div class="stat-box" style="background: #d4edda;">
                    <h3 style="margin: 0; color: #28a745;">Average Rating</h3>
                    <asp:Label ID="lblAvgRating" runat="server" Text="0.0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
                <div class="stat-box" style="background: #fff3cd;">
                    <h3 style="margin: 0; color: #ffc107;">Unique Employees</h3>
                    <asp:Label ID="lblUniqueEmployees" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
                <div class="stat-box" style="background: #f8d7da;">
                    <h3 style="margin: 0; color: #dc3545;">Lowest Rating</h3>
                    <asp:Label ID="lblLowestRating" runat="server" Text="0" Style="font-size: 24px; font-weight: bold;"></asp:Label>
                </div>
            </div>
            
            <!-- Performance Grid -->
            <div style="overflow-x: auto;">
                <asp:GridView ID="gvPerformance" runat="server" AutoGenerateColumns="false" 
                    CssClass="performance-table" GridLines="None" ShowHeaderWhenEmpty="true"
                    EmptyDataText="No performance records found for Winter semesters"
                    AllowPaging="true" PageSize="15" OnPageIndexChanging="gvPerformance_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="performance_ID" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="emp_ID" HeaderText="Employee ID" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="employee_name" HeaderText="Employee Name" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="department" HeaderText="Department" ItemStyle-Width="120px" />
                        <asp:TemplateField HeaderText="Rating" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <div class='<%# GetRatingClass(Eval("rating")) %>'>
                                    <span class="rating-star">
                                        <%# GetStarRating(Eval("rating")) %>
                                    </span>
                                    (<%# Eval("rating") %>)
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="semester" HeaderText="Semester" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="comments" HeaderText="Comments" ItemStyle-Width="200px" 
                            ItemStyle-CssClass="comments-cell" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <asp:Button ID="btnViewDetails" runat="server" Text="📋 Details" 
                                    CommandArgument='<%# Eval("performance_ID") %>' 
                                    OnClick="btnViewDetails_Click"
                                    CssClass="button" style="padding: 5px 10px; font-size: 12px;" />
                                <asp:Button ID="btnViewEmployee" runat="server" Text="👤 Profile" 
                                    CommandArgument='<%# Eval("emp_ID") %>' 
                                    OnClick="btnViewEmployee_Click"
                                    CssClass="button button-secondary" style="padding: 5px 10px; font-size: 12px; margin-top: 5px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#007bff" ForeColor="White" Font-Bold="true" />
                    <RowStyle CssClass="table-row" />
                    <AlternatingRowStyle BackColor="#f9f9f9" />
                    <EmptyDataRowStyle CssClass="no-data" />
                    <PagerStyle CssClass="pager" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
            
            <!-- Rating Distribution Chart (simplified) -->
            <div style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 20px;">
                <h3>Rating Distribution</h3>
                <div style="display: flex; align-items: flex-end; height: 200px; margin-top: 20px; gap: 10px;">
                    <div style="flex: 1; text-align: center;">
                        <div id="bar1" runat="server" style="background: #dc3545; height: 40px;"></div>
                        <div>1 Star<br /><asp:Label ID="lblRating1" runat="server" Text="0"></asp:Label></div>
                    </div>
                    <div style="flex: 1; text-align: center;">
                        <div id="bar2" runat="server" style="background: #fd7e14; height: 60px;"></div>
                        <div>2 Stars<br /><asp:Label ID="lblRating2" runat="server" Text="0"></asp:Label></div>
                    </div>
                    <div style="flex: 1; text-align: center;">
                        <div id="bar3" runat="server" style="background: #ffc107; height: 80px;"></div>
                        <div>3 Stars<br /><asp:Label ID="lblRating3" runat="server" Text="0"></asp:Label></div>
                    </div>
                    <div style="flex: 1; text-align: center;">
                        <div id="bar4" runat="server" style="background: #20c997; height: 100px;"></div>
                        <div>4 Stars<br /><asp:Label ID="lblRating4" runat="server" Text="0"></asp:Label></div>
                    </div>
                    <div style="flex: 1; text-align: center;">
                        <div id="bar5" runat="server" style="background: #28a745; height: 120px;"></div>
                        <div>5 Stars<br /><asp:Label ID="lblRating5" runat="server" Text="0"></asp:Label></div>
                    </div>
                </div>
            </div>
            
            <!-- Export Options -->
            <div style="margin-top: 20px; border-top: 1px solid #ddd; padding-top: 20px;">
                <h3>Export Options</h3>
                <asp:Button ID="btnExportExcel" runat="server" Text="📊 Export to Excel" OnClick="btnExportExcel_Click" CssClass="button" />
                <asp:Button ID="btnExportPDF" runat="server" Text="📄 Export Report" OnClick="btnExportPDF_Click" CssClass="button" Enabled="false" />
                <asp:Button ID="btnPrint" runat="server" Text="🖨️ Print Report" OnClick="btnPrint_Click" CssClass="button" 
                    OnClientClick="window.print(); return false;" />
            </div>
        </div>
    </form>
</body>
</html>
