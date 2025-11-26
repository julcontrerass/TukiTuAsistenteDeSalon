<%@ Page Title="Mesas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mesas.aspx.cs" Inherits="TukiGestor.Mesas" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/mesas") %>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    

    <div class="mesas-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-grid-3x3"></i> Gestion de Mesas
            </h2>

            <!-- Mensaje de notificación -->
            <asp:Panel ID="PanelMensaje" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                <asp:Literal ID="LitMensaje" runat="server"></asp:Literal>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <!-- Tabs Navigation - Clases CSS generadas desde C# -->
            <asp:HiddenField ID="HdnTabActivo" runat="server" Value="salon" />
            <ul class="nav nav-tabs" id="mesasTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= HdnTabActivo.Value == "salon" || string.IsNullOrEmpty(HdnTabActivo.Value) ? "active" : "" %>"
                            id="salon-tab" data-bs-toggle="tab" data-bs-target="#salon" type="button" role="tab"
                            onclick="document.getElementById('<%= HdnTabActivo.ClientID %>').value='salon'">
                        <i class="bi bi-house-door"></i> Salon
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= HdnTabActivo.Value == "patio" ? "active" : "" %>"
                            id="patio-tab" data-bs-toggle="tab" data-bs-target="#patio" type="button" role="tab"
                            onclick="document.getElementById('<%= HdnTabActivo.ClientID %>').value='patio'">
                        <i class="bi bi-tree"></i> Patio
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link <%= HdnTabActivo.Value == "mostrador" ? "active" : "" %>"
                            id="mostrador-tab" data-bs-toggle="tab" data-bs-target="#mostrador" type="button" role="tab"
                            onclick="document.getElementById('<%= HdnTabActivo.ClientID %>').value='mostrador'">
                        <i class="bi bi-shop"></i> Mostrador
                    </button>
                </li>
            </ul>

            <!-- Tabs Content - Clases CSS generadas desde C# -->
            <div class="tab-content" id="mesasTabContent">
                <!-- Salón Tab -->
                <div class="tab-pane fade <%= (HdnTabActivo.Value == "salon" || string.IsNullOrEmpty(HdnTabActivo.Value)) ? "show active" : "" %>" id="salon" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mesas del Salon</div>
                        <div class="edit-mode-buttons">
                            <button type="button" class="btn btn-warning btn-edit-mode" data-ubicacion="salon" onclick="toggleEditMode('salon')">
                                <i class="bi bi-pencil-square"></i> Editar Mesas
                            </button>
                            <button type="button" class="btn btn-success btn-save-mode" data-ubicacion="salon" onclick="savePositions('salon')" style="display: none;">
                                <i class="bi bi-check-circle"></i> Guardar Cambios
                            </button>
                            <button type="button" class="btn btn-secondary btn-cancel-mode" data-ubicacion="salon" onclick="cancelEditMode('salon')" style="display: none;">
                                <i class="bi bi-x-circle"></i> Cancelar
                            </button>
                        </div>
                    </div>
                    <div class="mesas-canvas" data-ubicacion="salon">
                        <asp:Repeater ID="RepMesasSalon" runat="server">
                            <ItemTemplate>
                                <div class="mesa-container" style='<%# "position: absolute; left: " + (Eval("PosicionX") ?? "0") + "px; top: " + (Eval("PosicionY") ?? "0") + "px; width: 150px; height: 150px;" %>' data-mesa-id='<%# Eval("MesaId") %>'>
                                    <asp:LinkButton ID="LnkMesa" runat="server"
                                        CssClass='<%# "mesa-card " + ((string)Eval("Estado")).ToLower() %>'
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|salon|" + Eval("Estado") %>'
                                        OnClick="SeleccionarMesa_Click"
                                        OnClientClick="return handleMesaClick(this, 'salon');"
                                        style="position: relative; width: 150px !important; height: 150px !important; left: 0; top: 0;">
                                        <div class="mesa-number"><%# Eval("NumeroMesa") %></div>
                                        <i class="bi bi-octagon-fill mesa-icon"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="LnkEliminarMesa" runat="server"
                                        CssClass="delete-btn"
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|salon" %>'
                                        OnClick="AbrirModalEliminarMesa_Click"
                                        Visible='<%# ((string)Eval("Estado")).ToLower() == "libre" %>'>
                                        <i class="bi bi-x"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="LnkAgregarSalon" runat="server" CssClass="add-mesa-canvas" CommandArgument="salon" OnClick="AgregarMesa_Click">
                            <i class="bi bi-plus-lg"></i>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Patio Tab -->
                <div class="tab-pane fade <%= HdnTabActivo.Value == "patio" ? "show active" : "" %>" id="patio" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mesas del Patio</div>
                        <div class="edit-mode-buttons">
                            <button type="button" class="btn btn-warning btn-edit-mode" data-ubicacion="patio" onclick="toggleEditMode('patio')">
                                <i class="bi bi-pencil-square"></i> Editar Mesas
                            </button>
                            <button type="button" class="btn btn-success btn-save-mode" data-ubicacion="patio" onclick="savePositions('patio')" style="display: none;">
                                <i class="bi bi-check-circle"></i> Guardar Cambios
                            </button>
                            <button type="button" class="btn btn-secondary btn-cancel-mode" data-ubicacion="patio" onclick="cancelEditMode('patio')" style="display: none;">
                                <i class="bi bi-x-circle"></i> Cancelar
                            </button>
                        </div>
                    </div>
                    <div class="mesas-canvas" data-ubicacion="patio">
                        <asp:Repeater ID="RepMesasPatio" runat="server">
                            <ItemTemplate>
                                <div class="mesa-container" style='<%# "position: absolute; left: " + (Eval("PosicionX") ?? "0") + "px; top: " + (Eval("PosicionY") ?? "0") + "px; width: 150px; height: 150px;" %>' data-mesa-id='<%# Eval("MesaId") %>'>
                                    <asp:LinkButton ID="LnkMesa" runat="server"
                                        CssClass='<%# "mesa-card " + ((string)Eval("Estado")).ToLower() %>'
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|patio|" + Eval("Estado") %>'
                                        OnClick="SeleccionarMesa_Click"
                                        OnClientClick="return handleMesaClick(this, 'patio');"
                                        style="position: relative; width: 150px !important; height: 150px !important; left: 0; top: 0;">
                                        <div class="mesa-number"><%# Eval("NumeroMesa") %></div>
                                        <i class="bi bi-octagon-fill mesa-icon"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="LnkEliminarMesa" runat="server"
                                        CssClass="delete-btn"
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|patio" %>'
                                        OnClick="AbrirModalEliminarMesa_Click"
                                        Visible='<%# ((string)Eval("Estado")).ToLower() == "libre" %>'>
                                        <i class="bi bi-x"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="LnkAgregarPatio" runat="server" CssClass="add-mesa-canvas" CommandArgument="patio" OnClick="AgregarMesa_Click">
                            <i class="bi bi-plus-lg"></i>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Mostrador Tab -->
                <div class="tab-pane fade <%= HdnTabActivo.Value == "mostrador" ? "show active" : "" %>" id="mostrador" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mostrador</div>
                        <div class="action-buttons">
                            <asp:LinkButton ID="LnkAbrirMostrador" runat="server" CssClass="btn btn-success btn-lg px-5 shadow-sm" OnClick="AbrirMostrador_Click">
                                <i class="bi bi-shop"></i> Abrir Mostrador
                            </asp:LinkButton>
                        </div>
                    </div>
                    <div id="ordenes-mostrador-container">
                        <asp:Repeater ID="RepOrdenesMostrador" runat="server">
                            <ItemTemplate>
                                <asp:LinkButton ID="LnkOrden" runat="server"
                                    CssClass="orden-mostrador-card"
                                    CommandArgument='<%# Eval("PedidoId") + "|" + Eval("NumeroMesa") + "|" + Eval("Ubicacion") %>'
                                    OnClick="SeleccionarOrdenMostrador_Click">
                                    <div class="orden-mostrador-header">
                                        <div>
                                            <div class="orden-mostrador-id">Orden #<%# Eval("PedidoId") %></div>
                                            <div class="orden-mostrador-fecha"><%# ((DateTime)Eval("FechaPedido")).ToString("dd/MM/yyyy HH:mm") %></div>
                                        </div>
                                        <div style="text-align: right;">
                                            <div style="font-weight: 600; color: #666;"><%# Eval("Ubicacion").ToString().ToUpper() %></div>
                                            <%# (bool)Eval("MostrarMesa") ? "<div style='font-size: 14px; color: #999;'>Mesa: " + Eval("NumeroMesa") + "</div>" : "" %>
                                        </div>
                                    </div>
                                    <div class="orden-mostrador-productos">
                                        <%# GenerarDetallesOrden((int)Eval("PedidoId")) %>
                                    </div>
                                    <div class="orden-mostrador-total">Total: $<%# ((decimal)Eval("Total")).ToString("N0") %></div>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Abrir Mesa -->
    <div class="modal fade" id="modalAbrirMesa" tabindex="-1" aria-labelledby="modalAbrirMesaLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalAbrirMesaLabel">
                        <i class="bi bi-octagon-fill"></i> Abrir Mesa <asp:Literal ID="LitNumeroMesaModal" runat="server"></asp:Literal>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="<%= TxtCantidadPersonas.ClientID %>" class="form-label">
                            <i class="bi bi-people-fill"></i> Cantidad de Personas
                        </label>
                        <asp:TextBox ID="TxtCantidadPersonas" runat="server" CssClass="form-control" TextMode="Number" min="1" placeholder="Ingrese cantidad de personas" Text="1"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <label for="<%= DdlCamarero.ClientID %>" class="form-label">
                            <i class="bi bi-person-badge"></i> Camarero Asignado
                        </label>
                        <asp:DropDownList ID="DdlCamarero" runat="server" CssClass="form-select" EnableViewState="true">
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="BtnConfirmarAbrirMesa" runat="server" CssClass="btn-abrir-mesa" Text="Abrir Mesa" OnClick="ConfirmarAbrirMesa_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Orden -->
    <div class="modal fade" id="modalOrden" tabindex="-1" aria-labelledby="modalOrdenLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <h5 class="modal-title" id="modalOrdenLabel">
                            <i class="bi bi-clipboard-check"></i> Tomar Orden - Mesa <span id="modal-orden-mesa-numero"></span>
                        </h5>
                        <asp:Panel ID="PanelMeseroOrden" runat="server" Visible="false" style="margin-top: 5px;">
                            <small style="color: #666;">
                                Mesero:
                                <asp:Literal ID="LitNombreMeseroOrden" runat="server"></asp:Literal>
                            </small>
                        </asp:Panel>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanelProductos" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="mb-3">
                                <label class="form-label">
                                    Buscar Producto
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <asp:TextBox ID="TxtBuscarProducto" runat="server"
                                        CssClass="form-control"
                                        placeholder="Buscar en todas las categorias..."
                                        onkeydown="return handleEnterBusqueda(event);"
                                        OnTextChanged="BuscarProducto_TextChanged">
                                    </asp:TextBox>
                                    <asp:LinkButton ID="BtnLimpiarBusqueda" runat="server"
                                        CssClass="btn btn-outline-secondary"
                                        OnClick="LimpiarBusqueda_Click"
                                        Style="display: none;">
                                        <i class="bi bi-x-circle-fill"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>

                            <% if (!HayBusquedaActiva) { %>
                                <!-- Tabs de categorias dinámicos -->
                                <ul class="nav nav-pills categorias-tabs" id="categoriasTabs" role="tablist">
                                    <asp:Repeater ID="RepCategorias" runat="server">
                                        <ItemTemplate>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link <%# Container.ItemIndex == 0 ? "active" : "" %>"
                                                        id='categoria-<%# Eval("CategoriaId") %>-tab'
                                                        data-bs-toggle="pill"
                                                        data-bs-target='#categoria-<%# Eval("CategoriaId") %>'
                                                        type="button"
                                                        role="tab">
                                                    <i class="bi bi-tag-fill"></i> <%# Eval("Nombre") %>
                                                </button>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>

                                <!-- Contenido de tabs dinámico -->
                                <div class="tab-content" id="categoriasTabContent">
                                    <asp:Repeater ID="RepCategoriasContenido" runat="server" DataSource='<%# Categorias %>'>
                                        <ItemTemplate>
                                            <div class='tab-pane fade <%# Container.ItemIndex == 0 ? "show active" : "" %>'
                                                 id='categoria-<%# Eval("CategoriaId") %>'
                                                 role="tabpanel">
                                                <div class="productos-lista">
                                                    <%# GenerarProductosCategoria((int)Eval("CategoriaId")) %>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            <% } else { %>
                                <!-- Resultados de búsqueda -->
                                <div id="resultadosBusqueda">
                                    <h6 style="color: #666; margin-bottom: 15px;">
                                        <i class="bi bi-search"></i> Resultados de busqueda para "<%= TxtBuscarProducto.Text %>"
                                    </h6>
                                    <div class="productos-lista">
                                        <%= GenerarProductosBusqueda() %>
                                    </div>
                                </div>
                            <% } %>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="orden-resumen">
                        <h6 style="color: #333; font-weight: bold; margin-bottom: 15px;">
                            <i class="bi bi-receipt"></i> Resumen de la Orden
                        </h6>
                        <div id="resumenOrden" class="mb-2">
                            <p style="color: #999; font-style: italic;">No hay productos seleccionados</p>
                        </div>
                        <div class="orden-total">
                            <span>Total:</span>
                            <span id="totalOrden">$0</span>
                        </div>
                    </div>

                    <button type="button" class="btn btn-success mt-3 w-100 py-3" style="font-weight: 600; font-size: 16px;" onclick="confirmarOrden()">
                        <i class="bi bi-check-circle-fill"></i> Confirmar Orden
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Resumen y Pago -->
    <div class="modal fade" id="modalResumenPago" tabindex="-1" aria-labelledby="modalResumenPagoLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalResumenPagoLabel">
                        <i class="bi bi-receipt-cutoff"></i> Orden #<span id="modal-numero-orden"></span> - Mesa <span id="modal-resumen-mesa-numero"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Información de la orden -->
                    <div class="orden-info mb-3" style="background: #F6EFE0; padding: 15px; border-radius: 8px;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                            <span style="color: #666;">Fecha:</span>
                            <span id="modal-fecha-orden" style="font-weight: 600;"></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                            <span style="color: #666;">Mesa:</span>
                            <span id="modal-ubicacion-mesa" style="font-weight: 600;"></span>
                        </div>
                        <div id="divMeseroResumen" style="display: flex; justify-content: space-between;">
                            <span style="color: #666;">Mesero:</span>
                            <span id="spanNombreMeseroResumen" style="font-weight: 600;">
                                <asp:Literal ID="LitNombreMesero" runat="server"></asp:Literal>
                            </span>
                        </div>
                    </div>

                    <!-- Lista de productos -->
                    <h6 style="color: #333; font-weight: bold; margin-bottom: 15px;">
                        <i class="bi bi-cart-check"></i> Productos
                    </h6>
                    <div class="resumen-completo" id="resumenCompleto" style="max-height: 300px; overflow-y: auto;">
                        <!-- Se llenara con JavaScript -->
                    </div>

                    <div class="orden-resumen mt-4">
                        <div class="orden-total">
                            <span>Total a Pagar:</span>
                            <span id="totalPagar" style="color: #28a745;">$0</span>
                        </div>
                    </div>

                    <div class="d-flex flex-column gap-3 mt-4">
                        <asp:LinkButton ID="LnkAgregarMasProductos" runat="server"
                            CssClass="btn btn-warning w-100 py-3"
                            style="font-weight: 600; font-size: 16px; text-decoration: none;"
                            OnClick="AgregarMasProductos_Click">
                            <i class="bi bi-plus-circle"></i> Agregar Mas Productos
                        </asp:LinkButton>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-danger flex-fill py-3" style="font-weight: 600; font-size: 16px;"
                                data-bs-toggle="modal" data-bs-target="#modalConfirmarCancelarOrden">
                                <i class="bi bi-trash"></i> Cancelar Orden
                            </button>
                            <button type="button" class="btn btn-success flex-fill py-3" style="font-weight: 600; font-size: 16px;"
                                data-bs-toggle="modal" data-bs-target="#modalRealizarPago">
                                <i class="bi bi-cash-coin"></i> Realizar Pago
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Confirmacion Eliminar Mesa -->
    <div class="modal fade" id="modalEliminarMesa" tabindex="-1" aria-labelledby="modalEliminarMesaLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="modalEliminarMesaLabel">
                        <i class="bi bi-exclamation-triangle-fill"></i> Confirmar Eliminacion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-trash3-fill text-danger" style="font-size: 48px;"></i>
                    <p class="mt-3 mb-0" style="font-size: 16px;">Estas seguro de que deseas eliminar la mesa <strong><span id="modalEliminarNumero"></span></strong>?</p>
                    <p class="text-muted mt-2">La mesa se ocultara pero se mantendra en el historial.</p>
                    <asp:HiddenField ID="HdnMesaIdEliminar" runat="server" />
                    <asp:HiddenField ID="HdnMesaNumeroEliminar" runat="server" />
                    <asp:HiddenField ID="HdnMesaUbicacionEliminar" runat="server" />
                    <asp:HiddenField ID="HdnProductosOrden" runat="server" EnableViewState="true" />
                    <asp:HiddenField ID="HdnPedidoIdActual" runat="server" EnableViewState="true" />
                    <asp:HiddenField ID="HdnPosicionesMesas" runat="server" EnableViewState="true" />
                    <asp:Button ID="BtnConfirmarOrdenHidden" runat="server" Style="display:none;" OnClick="ConfirmarOrden_Click" />
                    <asp:Button ID="BtnRealizarPagoHidden" runat="server" Style="display:none;" OnClick="RealizarPago_Click" />
                    <asp:Button ID="BtnCancelarOrdenHidden" runat="server" Style="display:none;" OnClick="CancelarOrden_Click" />
                    <asp:Button ID="BtnAgregarMasProductosHidden" runat="server" Style="display:none;" OnClick="AgregarMasProductos_Click" />
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> Cancelar
                    </button>
                    <asp:Button ID="BtnConfirmarEliminar" runat="server" CssClass="btn btn-danger px-4" Text="Eliminar" OnClick="ConfirmarEliminarMesa_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Confirmacion Cancelar Orden -->
    <div class="modal fade" id="modalConfirmarCancelarOrden" tabindex="-1" aria-labelledby="modalConfirmarCancelarOrdenLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="modalConfirmarCancelarOrdenLabel">
                        <i class="bi bi-exclamation-triangle-fill"></i> Confirmar Cancelacion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-trash3-fill text-danger" style="font-size: 64px;"></i>
                    <h5 class="mt-3 mb-2">Estas seguro de que deseas cancelar esta orden?</h5>
                    <p class="text-muted">Se perderan todos los productos de esta orden y no podras recuperarlos.</p>
                    <div class="alert alert-warning mt-3" role="alert">
                        <i class="bi bi-exclamation-circle"></i> Esta accion no se puede deshacer
                    </div>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> No, Volver
                    </button>
                    <button type="button" class="btn btn-danger px-4"
                        onclick="<%= Page.ClientScript.GetPostBackEventReference(BtnCancelarOrdenHidden, "") %>">
                        <i class="bi bi-trash-fill"></i> Si, Cancelar Orden
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Realizar Pago -->
    <div class="modal fade" id="modalRealizarPago" tabindex="-1" aria-labelledby="modalRealizarPagoLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content" style="border-radius: 15px; overflow: hidden; border: 2px solid #E7D9C2;">
                <div class="modal-header" style="background: #E7D9C2; border: none; padding: 25px;">
                    <div>
                        <h4 class="modal-title mb-1" id="modalRealizarPagoLabel" style="color: #333;">
                            <i class="bi bi-credit-card-fill"></i> Procesar Pago
                        </h4>
                        <p class="mb-0" style="font-size: 14px; color: #666;">Orden #<span id="modal-pago-numero-orden"></span></p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 30px; background: #F6EFE0;">
                    <div class="row g-4">
                        <!-- COLUMNA IZQUIERDA - DETALLES DE LA ORDEN -->
                        <div class="col-md-6">
                            <!-- Informacion del Cliente -->
                            <div class="card shadow-sm mb-3" style="border: 1px solid #C19A6B; border-radius: 12px; background: white;">
                                <div class="card-body" style="padding: 20px;">
                                    <h6 class="card-title mb-3" style="color: #333; font-weight: bold; font-size: 16px;">
                                        <i class="bi bi-info-circle-fill" style="color: #C19A6B;"></i> Detalles de la Orden
                                    </h6>
                                    <div class="row g-3">
                                        <div class="col-6">
                                            <div style="background: #E7D9C2; padding: 12px; border-radius: 8px;">
                                                <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Fecha y Hora</small>
                                                <div id="modal-pago-fecha" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div style="background: #E7D9C2; padding: 12px; border-radius: 8px;">
                                                <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Mesa</small>
                                                <div id="modal-pago-mesa" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                            </div>
                                        </div>
                                        <div id="divMeseroPago" class="col-12">
                                            <div style="background: #E7D9C2; padding: 12px; border-radius: 8px; border-left: 4px solid #C19A6B;">
                                                <small class="text-muted d-block mb-1" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Atendido por</small>
                                                <div id="modal-pago-mesero" style="font-weight: 600; color: #333; font-size: 14px;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Lista de Productos -->
                            <div class="card shadow-sm" style="border: 1px solid #E7D9C2; border-radius: 12px; background: white;">
                                <div class="card-body" style="padding: 20px;">
                                    <h6 class="card-title mb-3" style="color: #333; font-weight: bold; font-size: 16px;">
                                        <i class="bi bi-cart-check-fill" style="color: #C19A6B;"></i> Productos Ordenados
                                    </h6>
                                    <div id="modal-pago-productos" style="max-height: 280px; overflow-y: auto; margin: -5px;">
                                        <!-- Se llenara con JavaScript -->
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- COLUMNA DERECHA - PAGO -->
                        <div class="col-md-6">
                            <!-- Total a Pagar -->
                            <div class="card shadow-sm mb-3" style="border: 2px solid #E7D9C2; border-radius: 12px; background: #E7D9C2;">
                                <div class="card-body text-center" style="padding: 25px;">
                                    <p class="mb-2" style="font-size: 14px; color: #666; text-transform: uppercase; letter-spacing: 1px; font-weight: 600;">Total a Pagar</p>
                                    <h2 id="modal-pago-total" class="mb-0" style="font-size: 48px; font-weight: bold; color: #8B7355;">$0</h2>
                                </div>
                            </div>

                            <!-- Metodos de Pago -->
                            <div class="card shadow-sm mb-3" style="border: 1px solid #E7D9C2; border-radius: 12px; background: white;">
                                <div class="card-body" style="padding: 20px;">
                                    <h6 class="card-title mb-3" style="color: #333; font-weight: bold; font-size: 16px;">
                                        <i class="bi bi-wallet2" style="color: #C19A6B;"></i> Metodo de Pago
                                    </h6>
                                    <div class="d-grid gap-2">
                                        <label class="btn text-start" style="border: 2px solid #E7D9C2; border-radius: 10px; padding: 15px; position: relative; transition: all 0.3s; background: white;">
                                            <input class="form-check-input" type="radio" name="metodoPago" id="radioEfectivo" value="Efectivo" checked onchange="toggleMontoRecibido()" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); width: 20px; height: 20px;">
                                            <div>
                                                <i class="bi bi-cash-stack" style="font-size: 24px; color: #C19A6B;"></i>
                                                <span class="ms-2" style="font-weight: 600; font-size: 16px; color: #333;">Efectivo</span>
                                            </div>
                                        </label>
                                        <label class="btn text-start" style="border: 2px solid #E7D9C2; border-radius: 10px; padding: 15px; position: relative; transition: all 0.3s; background: white;">
                                            <input class="form-check-input" type="radio" name="metodoPago" id="radioTarjeta" value="Tarjeta" onchange="toggleMontoRecibido()" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); width: 20px; height: 20px;">
                                            <div>
                                                <i class="bi bi-credit-card-2-front" style="font-size: 24px; color: #C19A6B;"></i>
                                                <span class="ms-2" style="font-weight: 600; font-size: 16px; color: #333;">Tarjeta</span>
                                            </div>
                                        </label>
                                        <label class="btn text-start" style="border: 2px solid #E7D9C2; border-radius: 10px; padding: 15px; position: relative; transition: all 0.3s; background: white;">
                                            <input class="form-check-input" type="radio" name="metodoPago" id="radioTransferencia" value="Transferencia" onchange="toggleMontoRecibido()" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); width: 20px; height: 20px;">
                                            <div>
                                                <i class="bi bi-arrow-left-right" style="font-size: 24px; color: #C19A6B;"></i>
                                                <span class="ms-2" style="font-weight: 600; font-size: 16px; color: #333;">Transferencia</span>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Monto Recibido (solo efectivo) -->
                            <div id="divMontoRecibido" class="card shadow-sm" style="border: 1px solid #E7D9C2; border-radius: 12px; background: white;">
                                <div class="card-body" style="padding: 20px;">
                                    <label for="txtMontoRecibido" class="form-label" style="font-weight: 600; color: #333; font-size: 14px;">
                                        <i class="bi bi-currency-dollar" style="color: #C19A6B;"></i> Monto Recibido del Cliente
                                    </label>
                                    <input type="number" class="form-control form-control-lg" id="txtMontoRecibido"
                                        placeholder="$0.00" step="0.01" min="0"
                                        oninput="calcularVuelto()"
                                        style="font-size: 24px; font-weight: bold; border: 2px solid #E7D9C2; border-radius: 10px; text-align: center;">

                                    <!-- Vuelto -->
                                    <div id="divVuelto" class="mt-3" style="display: none;">
                                        <div style="background: #E7D9C2; padding: 15px; border-radius: 10px; text-align: center; border: 2px solid #E7D9C2;">
                                            <small class="d-block mb-1" style="color: #666; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 600;">Vuelto a Entregar</small>
                                            <h4 id="spanVuelto" class="mb-0" style="font-size: 32px; font-weight: bold; color: #333;">$0</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden fields para enviar al servidor -->
                    <asp:HiddenField ID="HdnMetodoPago" runat="server" />
                    <asp:HiddenField ID="HdnMontoRecibido" runat="server" />
                </div>
                <div class="modal-footer" style="border-top: 2px solid #E7D9C2; padding: 20px 30px; background: #F6EFE0;">
                    <button type="button" class="btn btn-lg px-5" data-bs-dismiss="modal" style="border-radius: 10px; background: #6c757d; color: white; border: none;">
                        <i class="bi bi-x-circle"></i> Cancelar
                    </button>
                    <button type="button" class="btn btn-lg px-5" onclick="confirmarPago()" style="border-radius: 10px; background: #E7D9C2; color: #333; border: none; font-weight: 600; box-shadow: 0 4px 8px rgba(193, 154, 107, 0.3);">
                        <i class="bi bi-check-circle-fill"></i> Confirmar Pago
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Confirmacion Pago Exitoso -->
    <div class="modal fade" id="modalPagoExitoso" tabindex="-1" aria-labelledby="modalPagoExitosoLabel" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px; overflow: hidden; border: 2px solid #E7D9C2;">
                <div class="modal-body text-center" style="padding: 50px 40px; background: #F6EFE0;">
                    <div class="mb-4">
                        <div style="width: 100px; height: 100px; background: #E7D9C2; border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center; box-shadow: 0 8px 16px rgba(193, 154, 107, 0.3);">
                            <i class="bi bi-check-lg" style="font-size: 60px; font-weight: bold; color: #333;"></i>
                        </div>
                    </div>
                    <h3 class="mb-3" style="color: #8B7355; font-weight: bold;">Pago Confirmado!</h3>
                    <p class="text-muted mb-4" style="font-size: 16px;">El pago se ha procesado exitosamente.</p>
                    <div class="alert" style="background: white; border: 2px solid #E7D9C2; border-radius: 10px; padding: 20px;">
                        <div class="d-flex justify-content-between mb-2">
                            <span style="color: #666;">Orden:</span>
                            <strong id="modal-exito-orden" style="color: #333;">#0</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span style="color: #666;">Metodo de Pago:</span>
                            <strong id="modal-exito-metodo" style="color: #333;">-</strong>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span style="color: #666;">Total Pagado:</span>
                            <strong id="modal-exito-total" style="color: #8B7355; font-size: 18px;">$0</strong>
                        </div>
                    </div>
                    <button type="button" class="btn btn-lg px-5 mt-3" onclick="cerrarModalExito()" style="border-radius: 10px; background: #E7D9C2; color: #333; border: none; font-weight: 600; box-shadow: 0 4px 8px rgba(193, 154, 107, 0.3);">
                        <i class="bi bi-check-circle"></i> Aceptar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <asp:Button ID="BtnConfirmarPagoHidden" runat="server" Style="display:none;" OnClick="ConfirmarPago_Click" />

    <!-- Script externo para funcionalidad de mesas -->
    <script src="<%= ResolveUrl("~/Scripts/mesas.js") %>"></script>

    <!-- Configuración de IDs de controles ASP.NET para el script externo -->
    <script>
        // Configurar IDs de controles para el archivo externo
        window.hdnPosicionesMesasId = '<%= HdnPosicionesMesas.ClientID %>';
        window.hdnTabActivoId = '<%= HdnTabActivo.ClientID %>';
        window.hdnProductosOrdenId = '<%= HdnProductosOrden.ClientID %>';
        window.txtBuscarProductoId = '<%= TxtBuscarProducto.ClientID %>';
        window.txtBuscarProductoUniqueId = '<%= TxtBuscarProducto.UniqueID %>';
        window.btnLimpiarBusquedaId = '<%= BtnLimpiarBusqueda.ClientID %>';
        window.hdnMetodoPagoId = '<%= HdnMetodoPago.ClientID %>';
        window.hdnMontoRecibidoId = '<%= HdnMontoRecibido.ClientID %>';

        // Funciones de postback
        window.postbackConfirmarOrden = function() {
            <%= Page.ClientScript.GetPostBackEventReference(BtnConfirmarOrdenHidden, "") %>;
        };
        window.postbackConfirmarPago = function() {
            <%= Page.ClientScript.GetPostBackEventReference(BtnConfirmarPagoHidden, "") %>;
        };
    </script>
</asp:Content>
