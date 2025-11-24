<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Meseros.aspx.cs" Inherits="TukiGestor.Meseros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Styles/meseros.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="productos-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-people-fill"></i> Gestión de Meseros
            </h2>

            <asp:UpdatePanel ID="UpdatePanelMensajes" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert-custom">
                        <asp:Label ID="lblMensaje" runat="server"></asp:Label>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- Solapas -->
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabListado" runat="server" CssClass="nav-link active" OnClick="btnTabListado_Click">
                        <i class="bi bi-list-ul"></i> Meseros Activos
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabNuevo" runat="server" CssClass="nav-link" OnClick="btnTabNuevo_Click">
                        <i class="bi bi-plus-circle"></i> Nuevo Mesero
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabInactivos" runat="server" CssClass="nav-link" OnClick="btnTabInactivos_Click">
                        <i class="bi bi-archive"></i> Meseros Inactivos
                    </asp:LinkButton>
                </li>
            </ul>

            <!-- contenido de las solapas -->
            <asp:UpdatePanel ID="UpdatePanelContenido" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="tab-content mt-3">
                        <!-- listado -->
                        <asp:Panel ID="pnlListado" runat="server" CssClass="tab-pane fade active show">
                            <asp:Repeater ID="RepeaterMeseros" runat="server" OnItemCommand="RepeaterMeseros_ItemCommand">
                                <HeaderTemplate>
                                    <div class="tabla-scroll">
                                        <table class="table table-striped table-hover text-center shadow-lg">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Nombre Completo</th>
                                                    <th>Usuario</th>
                                                    <th>Email</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("MeseroId") %></td>
                                        <td><%# Eval("Nombre") + " " + Eval("Apellido") %></td>
                                        <td><%# Eval("NombreUsuario") %></td>
                                        <td><%# Eval("Email") %></td>
                                        <td>
                                            <asp:LinkButton runat="server" CssClass="btn btn-link text-danger" CommandName="Desactivar" CommandArgument='<%# Eval("MeseroId") %>'>
                                                <i class="bi bi-trash-fill"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                            </tbody>
                                        </table>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>
                        </asp:Panel>

                        <!-- nuevo mesero -->
                        <asp:Panel ID="pnlNuevo" runat="server" CssClass="tab-pane fade">
                            <div class="p-4">
                                <h4 class="mb-3">Agregar nuevo mesero</h4>
                                <div class="mb-3">
                                    <label for="txtNombreUsuario" class="form-label">Nombre de Usuario</label>
                                    <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label for="txtContrasenia" class="form-label">Contraseña</label>
                                    <asp:TextBox ID="txtContrasenia" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label for="txtEmail" class="form-label">Email</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="ejemplo@correo.com"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label for="txtNombreMesero" class="form-label">Nombre</label>
                                    <asp:TextBox ID="txtNombreMesero" runat="server" CssClass="form-control" placeholder="Ej: Juan"></asp:TextBox>
                                </div>
                                <div class="mb-3">
                                    <label for="txtApellidoMesero" class="form-label">Apellido</label>
                                    <asp:TextBox ID="txtApellidoMesero" runat="server" CssClass="form-control" placeholder="Ej: Pérez"></asp:TextBox>
                                </div>
                                <asp:Button ID="btnGuardarMesero" runat="server" Text="Guardar" CssClass="btn btn-custom mt-3" OnClick="btnGuardarMesero_Click" />
                            </div>
                        </asp:Panel>

                        <!-- meseros inactivos -->
                        <asp:Panel ID="pnlInactivos" runat="server" CssClass="tab-pane fade">
                            <div class="p-4">
                                <h4 class="mb-3 text-center">Meseros Inactivos</h4>
                                <asp:Repeater ID="RepeaterMeserosInactivos" runat="server" OnItemCommand="RepeaterMeserosInactivos_ItemCommand">
                                    <HeaderTemplate>
                                        <div class="tabla-scroll">
                                            <table class="table table-striped table-hover text-center shadow-lg">
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Nombre Completo</th>
                                                        <th>Usuario</th>
                                                        <th>Email</th>
                                                        <th>Acciones</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("MeseroId") %></td>
                                            <td><%# Eval("Nombre") + " " + Eval("Apellido") %></td>
                                            <td><%# Eval("NombreUsuario") %></td>
                                            <td><%# Eval("Email") %></td>
                                            <td>
                                                <asp:LinkButton runat="server" CssClass="btn btn-link text-success" CommandName="Reactivar" CommandArgument='<%# Eval("MeseroId") %>' ToolTip="Reactivar mesero">
                                                    <i class="bi bi-arrow-clockwise"></i> Reactivar
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                                </tbody>
                                            </table>
                                        </div>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
