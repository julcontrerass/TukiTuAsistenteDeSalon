<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Meseros.aspx.cs" Inherits="TukiGestor.Meseros" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Styles/meseros.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="productos-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-people-fill"></i>Gestión de Usuarios
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
                    <asp:LinkButton ID="btnTabListadoGerentes" runat="server" CssClass="nav-link" OnClick="btnTabListadoGerentes_Click">
                         <i class="bi bi-person-lines-fill"></i>> Gerentes Activos
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabNuevo" runat="server" CssClass="nav-link" OnClick="btnTabNuevo_Click">
                        <i class="bi bi-plus-circle"></i> Nuevo Usuario
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabModificar" runat="server" CssClass="nav-link" OnClick="btnTabModificar_Click" Visible="false">
                        <i class="bi bi-pencil-square"></i> Modificar Usuario
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
                    <asp:LinkButton ID="btnTabInactivos" runat="server" CssClass="nav-link" OnClick="btnTabInactivos_Click">
                        <i class="bi bi-archive"></i> Meseros Inactivos
                    </asp:LinkButton>
                </li>
                <li class="nav-item">
    <asp:LinkButton ID="btnTabGerentesInactivos" runat="server" CssClass="nav-link" OnClick="btnTabGerentesInactivos_Click">
        <i class="bi bi-trash3"></i> Gerentes Inactivos
    </asp:LinkButton>
</li>
            </ul>

            <!-- contenido de las solapas -->
            <asp:UpdatePanel ID="UpdatePanelContenido" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="tab-content mt-3">
                        <!-- listado meseros -->
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
                                            <asp:LinkButton runat="server" CssClass="btn btn-link text-primary me-2" CommandName="Editar" CommandArgument='<%# Eval("MeseroId") %>' ToolTip="Editar mesero">
                                                <i class="bi bi-pencil-fill"></i>
                                            </asp:LinkButton>
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
                        <!-- listado gerentes -->

                        <asp:Panel ID="PnlListadoGerentes" runat="server" CssClass="tab-pane fade">
                            <asp:Repeater ID="RepeaterGerentes" runat="server" OnItemCommand="RepeaterGerentes_ItemCommand">
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
                                        <td><%# Eval("GerenteId") %></td>
                                        <td><%# Eval("Nombre") + " " + Eval("Apellido") %></td>
                                        <td><%# Eval("NombreUsuario") %></td>
                                        <td><%# Eval("Email") %></td>


                                        <td>
                                            <asp:LinkButton runat="server" CssClass="btn btn-link text-primary me-2" CommandName="Editar" CommandArgument='<%# Eval("GerenteId") %>' ToolTip="Editar gerente">
                        <i class="bi bi-pencil-fill"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass="btn btn-link text-danger" CommandName="Desactivar" CommandArgument='<%# Eval("GerenteId") %>'>
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
                                <h4 class="mb-3">Agregar nuevo usuario</h4>
                                <div class="mb-3">
                                    <label for="txtNombreUsuario" class="form-label">Nombre de Usuario *</label>
                                    <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server" ControlToValidate="txtNombreUsuario" ErrorMessage="El nombre de usuario es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"></asp:RequiredFieldValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtContrasenia" class="form-label">Contraseña *</label>
                                    <asp:TextBox ID="txtContrasenia" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvContrasenia" runat="server" ControlToValidate="txtContrasenia" ErrorMessage="La contraseña es obligatoria." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revContrasenia" runat="server" ControlToValidate="txtContrasenia" ValidationExpression="^.{6,}$" ErrorMessage="La contraseña debe tener al menos 6 caracteres." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"> </asp:RegularExpressionValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtEmail" class="form-label">Email *</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="ejemplo@correo.com"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El email es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"> </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ErrorMessage="El formato del email no es válido." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"></asp:RegularExpressionValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtNombreMesero" class="form-label">Nombre *</label>
                                    <asp:TextBox ID="txtNombreMesero" runat="server" CssClass="form-control" placeholder="Ej: Juan"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombreMesero" runat="server" ControlToValidate="txtNombreMesero" ErrorMessage="El nombre es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"> </asp:RequiredFieldValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtApellidoMesero" class="form-label">Apellido *</label>
                                    <asp:TextBox ID="txtApellidoMesero" runat="server" CssClass="form-control" placeholder="Ej: Pérez"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvApellidoMesero" runat="server" ControlToValidate="txtApellidoMesero" ErrorMessage="El apellido es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="NuevoMesero"> </asp:RequiredFieldValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtRol" class="form-label">Rol *</label>
                                    <asp:DropDownList ID="ddlFiltroRol" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Gerente" Value="gerente"></asp:ListItem>
                                        <asp:ListItem Text="Mesero" Value="mesero"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <asp:Button ID="btnGuardarMesero" runat="server" Text="Guardar" CssClass="btn btn-custom mt-3" OnClick="btnGuardarMesero_Click" ValidationGroup="NuevoMesero" />
                            </div>
                        </asp:Panel>
                        <!-- modificar mesero -->
                        <asp:Panel ID="pnlModificar" runat="server" CssClass="tab-pane fade">
                            <div class="p-4">
                                <h4 class="mb-3">Modificar Usuario</h4>
                                <asp:HiddenField ID="hfMeseroId" runat="server" />
                                <asp:HiddenField ID="hfUsuarioId" runat="server" />
                                <div class="mb-3">
                                    <label class="form-label fw-bold">ID Mesero</label>
                                    <p class="form-control-plaintext">
                                        <asp:Label ID="lblMeseroIdMod" runat="server"></asp:Label>
                                    </p>
                                </div>
                                <div class="mb-3">
                                    <label for="txtNombreUsuarioMod" class="form-label">Nombre de Usuario *</label>
                                    <asp:TextBox ID="txtNombreUsuarioMod" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombreUsuarioMod" runat="server" ControlToValidate="txtNombreUsuarioMod" ErrorMessage="El nombre de usuario es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ModificarMesero">
                                    </asp:RequiredFieldValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtContraseniaMod" class="form-label">Contraseña</label>
                                    <asp:TextBox ID="txtContraseniaMod" runat="server" TextMode="Password" CssClass="form-control" placeholder="Dejar en blanco para no cambiar"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="revContraseniaMod" runat="server" ControlToValidate="txtContraseniaMod" ValidationExpression="^.{6,}$" ErrorMessage="La contraseña debe tener al menos 6 caracteres." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ModificarMesero"> </asp:RegularExpressionValidator>
                                    <small class="text-muted">Si no desea cambiar la contraseña, deje este campo vacío.</small>
                                </div>
                                <div class="mb-3">
                                    <label for="txtEmailMod" class="form-label">Email *</label>
                                    <asp:TextBox ID="txtEmailMod" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmailMod" runat="server" ControlToValidate="txtEmailMod" ErrorMessage="El email es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ModificarMesero"> </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmailMod" runat="server" ControlToValidate="txtEmailMod" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ErrorMessage="El formato del email no es válido." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ModificarMesero"></asp:RegularExpressionValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtNombreMeseroMod" class="form-label">Nombre *</label>
                                    <asp:TextBox ID="txtNombreMeseroMod" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombreMeseroMod" runat="server" ControlToValidate="txtNombreMeseroMod" ErrorMessage="El nombre es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ModificarMesero"> </asp:RequiredFieldValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtApellidoMeseroMod" class="form-label">Apellido *</label>
                                    <asp:TextBox ID="txtApellidoMeseroMod" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvApellidoMeseroMod" runat="server" ControlToValidate="txtApellidoMeseroMod" ErrorMessage="El apellido es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ModificarMesero"> </asp:RequiredFieldValidator>
                                </div>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnActualizarMesero" runat="server" Text="Guardar Cambios" CssClass="btn btn-custom" OnClick="btnActualizarMesero_Click" ValidationGroup="ModificarMesero" />
                                    <asp:Button ID="btnCancelarMod" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="btnCancelarMod_Click" CausesValidation="false" />
                                </div>
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


                        <!-- gerentes inactivos -->
                        <asp:Panel ID="PnlGerentesInactivos" runat="server" CssClass="tab-pane fade">
                            <div class="p-4">
                                <h4 class="mb-3 text-center">Gerentes Inactivos</h4>
                                <asp:Repeater ID="RepeaterGerentesInactivos" runat="server" OnItemCommand="RepeaterGerentesInactivos_ItemCommand">
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
                                            <td><%# Eval("GerenteId") %></td>
                                            <td><%# Eval("Nombre") + " " + Eval("Apellido") %></td>
                                            <td><%# Eval("NombreUsuario") %></td>
                                            <td><%# Eval("Email") %></td>
                                            <td>
                                                <asp:LinkButton runat="server" CssClass="btn btn-link text-success" CommandName="Reactivar" CommandArgument='<%# Eval("GerenteId") %>' ToolTip="Reactivar mesero">
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
