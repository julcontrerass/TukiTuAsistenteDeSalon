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
                    </div>
                    <div class="mesas-grid">
                        <asp:Repeater ID="RepMesasSalon" runat="server">
                            <ItemTemplate>
                                <div style="position: relative;">
                                    <asp:LinkButton ID="LnkMesa" runat="server"
                                        CssClass='<%# "mesa-card " + ((string)Eval("Estado")).ToLower() %>'
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|salon|" + Eval("Estado") %>'
                                        OnClick="SeleccionarMesa_Click">
                                        <div class="mesa-number"><%# Eval("NumeroMesa") %></div>
                                        <i class="bi bi-octagon-fill mesa-icon"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="LnkEliminarMesa" runat="server"
                                        CssClass="delete-btn"
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|salon" %>'
                                        OnClick="AbrirModalEliminarMesa_Click"
                                        OnClientClick="event.stopPropagation();">
                                        <i class="bi bi-x"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="LnkAgregarSalon" runat="server" CssClass="add-mesa-card" CommandArgument="salon" OnClick="AgregarMesa_Click">
                            <i class="bi bi-plus-lg"></i>
                            <div style="color: #666; font-size: 14px;">Agregar Mesa</div>
                        </asp:LinkButton>
                    </div>
                </div>

                <!-- Patio Tab -->
                <div class="tab-pane fade <%= HdnTabActivo.Value == "patio" ? "show active" : "" %>" id="patio" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mesas del Patio</div>
                    </div>
                    <div class="mesas-grid">
                        <asp:Repeater ID="RepMesasPatio" runat="server">
                            <ItemTemplate>
                                <div style="position: relative;">
                                    <asp:LinkButton ID="LnkMesa" runat="server"
                                        CssClass='<%# "mesa-card " + ((string)Eval("Estado")).ToLower() %>'
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|patio|" + Eval("Estado") %>'
                                        OnClick="SeleccionarMesa_Click">
                                        <div class="mesa-number"><%# Eval("NumeroMesa") %></div>
                                        <i class="bi bi-octagon-fill mesa-icon"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="LnkEliminarMesa" runat="server"
                                        CssClass="delete-btn"
                                        CommandArgument='<%# Eval("MesaId") + "|" + Eval("NumeroMesa") + "|patio" %>'
                                        OnClick="AbrirModalEliminarMesa_Click"
                                        OnClientClick="event.stopPropagation();">
                                        <i class="bi bi-x"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:LinkButton ID="LnkAgregarPatio" runat="server" CssClass="add-mesa-card" CommandArgument="patio" OnClick="AgregarMesa_Click">
                            <i class="bi bi-plus-lg"></i>
                            <div style="color: #666; font-size: 14px;">Agregar Mesa</div>
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
                        <asp:DropDownList ID="DdlCamarero" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">Seleccione un camarero</asp:ListItem>
                            <asp:ListItem Value="1">Juan Perez</asp:ListItem>
                            <asp:ListItem Value="2">Maria Gonzalez</asp:ListItem>
                            <asp:ListItem Value="3">Carlos Rodriguez</asp:ListItem>
                            <asp:ListItem Value="4">Ana Martinez</asp:ListItem>
                            <asp:ListItem Value="5">Luis Fernandez</asp:ListItem>
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
                    <h5 class="modal-title" id="modalOrdenLabel">
                        <i class="bi bi-clipboard-check"></i> Tomar Orden - Mesa <span id="modal-orden-mesa-numero"></span>
                    </h5>
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
                        <div style="display: flex; justify-content: space-between;">
                            <span style="color: #666;">Mesa:</span>
                            <span id="modal-ubicacion-mesa" style="font-weight: 600;"></span>
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
                        <button type="button" class="btn btn-warning w-100 py-3" style="font-weight: 600; font-size: 16px;" onclick="agregarMasProductos()">
                            <i class="bi bi-plus-circle"></i> Agregar Mas Productos
                        </button>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-danger flex-fill py-3" style="font-weight: 600; font-size: 16px;"
                                onclick="if (confirm('¿Estás seguro de que deseas cancelar esta orden? Se perderán todos los productos.')) { <%= Page.ClientScript.GetPostBackEventReference(BtnCancelarOrdenHidden, "") %>; }">
                                <i class="bi bi-trash"></i> Cancelar Orden
                            </button>
                            <button type="button" class="btn btn-success flex-fill py-3" style="font-weight: 600; font-size: 16px;"
                                onclick="<%= Page.ClientScript.GetPostBackEventReference(BtnRealizarPagoHidden, "") %>">
                                <i class="bi bi-cash-coin"></i> Realizar Pago
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Confirmación Eliminar Mesa -->
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
                    <p class="mt-3 mb-0" style="font-size: 16px;">¿Estas seguro de que deseas eliminar la mesa <strong><span id="modalEliminarNumero"></span></strong>?</p>
                    <p class="text-muted mt-2">Esta accion no se puede deshacer.</p>
                    <asp:HiddenField ID="HdnMesaIdEliminar" runat="server" />
                    <asp:HiddenField ID="HdnMesaNumeroEliminar" runat="server" />
                    <asp:HiddenField ID="HdnMesaUbicacionEliminar" runat="server" />
                    <asp:HiddenField ID="HdnProductosOrden" runat="server" />
                    <asp:HiddenField ID="HdnPedidoIdActual" runat="server" />
                    <asp:Button ID="BtnConfirmarOrdenHidden" runat="server" Style="display:none;" OnClick="ConfirmarOrden_Click" />
                    <asp:Button ID="BtnRealizarPagoHidden" runat="server" Style="display:none;" OnClick="RealizarPago_Click" />
                    <asp:Button ID="BtnCancelarOrdenHidden" runat="server" Style="display:none;" OnClick="CancelarOrden_Click" />
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

    <script>
        // Función helper para formatear números
        const formatearPrecio = (num) => '$' + Math.round(num).toLocaleString('es-AR');

        // ===== MANEJO DE PRODUCTOS =====
        function cambiarCantidad(boton, incremento, event) {
            event.preventDefault();
            event.stopPropagation();
            const input = boton.closest('.producto-item').querySelector('input[type="number"]');
            input.value = Math.max(0, (parseInt(input.value) || 0) + incremento);
            actualizarResumenOrden();
        }

        function actualizarResumenOrden() {
            const resumenDiv = document.getElementById('resumenOrden');
            const totalSpan = document.getElementById('totalOrden');
            const tieneExistentes = resumenDiv?.getAttribute('data-tiene-existentes') === 'true';
            const productosExistentes = window.productosExistentesOrden || [];

            // Recolectar productos nuevos
            const productosNuevos = Array.from(document.querySelectorAll('.producto-item'))
                .map(p => {
                    const cantidad = parseInt(p.querySelector('input[type="number"]').value) || 0;
                    return cantidad > 0 ? {
                        nombre: p.getAttribute('data-nombre'),
                        precio: parseFloat(p.getAttribute('data-precio')),
                        cantidad: cantidad,
                        subtotal: parseFloat(p.getAttribute('data-precio')) * cantidad
                    } : null;
                })
                .filter(p => p !== null);

            // Construir HTML
            let html = '';
            let total = 0;

            const generarItemHTML = (prod, tipo) => {
                total += prod.subtotal;
                return `<div class="resumen-item" data-tipo="${tipo}">
                    <div class="resumen-item-info">
                        <div class="resumen-item-nombre">${prod.nombre}</div>
                        <div class="resumen-item-cantidad">Cantidad: ${prod.cantidad} x ${formatearPrecio(prod.precio)}</div>
                    </div>
                    <div class="resumen-item-precio">${formatearPrecio(prod.subtotal)}</div>
                </div>`;
            };

            if (tieneExistentes) html += productosExistentes.map(p => generarItemHTML(p, 'existente')).join('');
            html += productosNuevos.map(p => generarItemHTML(p, 'nuevo')).join('');

            resumenDiv.innerHTML = html || '<p style="color: #999; font-style: italic;">No hay productos seleccionados</p>';
            totalSpan.textContent = html ? formatearPrecio(total) : '$0';
        }

        function confirmarOrden() {
            const productos = Array.from(document.querySelectorAll('.producto-item'))
                .map(p => {
                    const cantidad = parseInt(p.querySelector('input[type="number"]').value) || 0;
                    return cantidad > 0 ? {
                        ProductoId: parseInt(p.getAttribute('data-productoid')),
                        Cantidad: cantidad,
                        PrecioUnitario: parseFloat(p.getAttribute('data-precio')),
                        Nombre: p.getAttribute('data-nombre')
                    } : null;
                })
                .filter(p => p !== null);

            if (productos.length === 0) {
                alert('Por favor selecciona al menos un producto');
                return;
            }

            document.getElementById('<%= HdnProductosOrden.ClientID %>').value = JSON.stringify(productos);
            <%= Page.ClientScript.GetPostBackEventReference(BtnConfirmarOrdenHidden, "") %>;
        }

        // ===== MANEJO DE MODALS =====
        function agregarMasProductos() {
            bootstrap.Modal.getInstance(document.getElementById('modalResumenPago'))?.hide();
            setTimeout(() => {
                document.getElementById('modal-orden-mesa-numero').textContent =
                    document.getElementById('modal-resumen-mesa-numero').textContent;
                new bootstrap.Modal(document.getElementById('modalOrden')).show();
            }, 300);
        }

        // ===== BÚSQUEDA =====
        function handleEnterBusqueda(event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                __doPostBack('<%= TxtBuscarProducto.UniqueID %>', '');
                return false;
            }
            return true;
        }

        function mantenerFocoEnBusqueda() {
            const prm = Sys?.WebForms?.PageRequestManager?.getInstance();
            if (prm) {
                prm.add_endRequest(() => {
                    const txtBuscar = document.getElementById('<%= TxtBuscarProducto.ClientID %>');
                    if (txtBuscar) {
                        setTimeout(() => {
                            txtBuscar.focus();
                            txtBuscar.setSelectionRange?.(txtBuscar.value.length, txtBuscar.value.length);
                        }, 100);
                    }
                });
            }
        }

        function limpiarBusquedaAlCerrarModal() {
            const txtBuscar = document.getElementById('<%= TxtBuscarProducto.ClientID %>');
            const btnLimpiar = document.getElementById('<%= BtnLimpiarBusqueda.ClientID %>');
            if (txtBuscar?.value.trim() && btnLimpiar?.style.display !== 'none') {
                btnLimpiar.click();
            }
        }

        // ===== INICIALIZACIÓN =====
        document.addEventListener('DOMContentLoaded', () => {
            mantenerFocoEnBusqueda();

            // Event listeners de modales
            document.getElementById('modalOrden')?.addEventListener('hidden.bs.modal', limpiarBusquedaAlCerrarModal);
        });
    </script>
</asp:Content>
