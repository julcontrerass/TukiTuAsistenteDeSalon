<%@ Page Title="Mesas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mesas.aspx.cs" Inherits="TukiGestor.Mesas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .mesas-container {
            position: fixed;
            left: calc(50vw + 140px);
            top: 40px;
            transform: translateX(-50%);
            z-index: 100;
            width: 90%;
            max-width: 1400px;
            padding: 20px;
            padding-bottom: 120px;
        }

        .sidebar.collapsed ~ .main-wrapper .mesas-container {
            left: calc(50vw + 40px);
        }

        .tabs-container {
            background: #F6EFE0;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .nav-tabs {
            border-bottom: 2px solid #E7D9C2;
            margin-bottom: 30px;
        }

        .nav-tabs .nav-link {
            color: #333;
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 8px 8px 0 0;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link:hover {
            background-color: #E7D9C2;
            color: #333;
        }

        .nav-tabs .nav-link.active {
            background-color: #E7D9C2;
            color: #333;
            border: none;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .mesas-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .mesa-card {
            background: #F6EFE0;
            border: 2px solid #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            position: relative;
            display: flex !important;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
            color: inherit !important;
            min-height: 140px;
        }

        a.mesa-card {
            display: flex !important;
        }

        a.mesa-card:hover {
            text-decoration: none !important;
            color: inherit !important;
        }

        a.mesa-card:focus {
            text-decoration: none !important;
            color: inherit !important;
            outline: none;
        }

        .mesa-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }

        .mesa-card .mesa-icon {
            font-size: 80px;
            transition: all 0.3s ease;
            position: relative;
        }

        .mesa-card.libre .mesa-icon {
            color: #28a745;
        }

        .mesa-card.ocupada .mesa-icon {
            color: #dc3545;
        }

        .mesa-card .mesa-number {
            position: absolute;
            font-size: 28px;
            font-weight: bold;
            color: #fff;
            text-shadow: 0 0 3px rgba(0, 0, 0, 0.5);
            z-index: 1;
        }

        .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            font-size: 16px;
            cursor: pointer;
            display: none !important;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 10;
            text-decoration: none !important;
        }

        .mesas-grid > div:hover .delete-btn {
            display: flex !important;
        }

        .delete-btn:hover {
            background: #c82333 !important;
            transform: scale(1.1);
            color: white !important;
            text-decoration: none !important;
        }

        a.delete-btn {
            display: none !important;
            text-decoration: none !important;
        }

        .mesas-grid > div:hover a.delete-btn {
            display: flex !important;
        }

        .add-mesa-card {
            background: #F6EFE0;
            border: 2px dashed #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            display: flex !important;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 140px;
            text-decoration: none !important;
            color: inherit !important;
        }

        a.add-mesa-card {
            display: flex !important;
        }

        .add-mesa-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            background: #E7D9C2;
            text-decoration: none !important;
            color: inherit !important;
        }

        .add-mesa-card:focus {
            text-decoration: none !important;
            color: inherit !important;
            outline: none;
        }

        .add-mesa-card i {
            font-size: 50px;
            color: #28a745;
            margin-bottom: 10px;
        }


        .modal-content {
            border-radius: 15px;
            border: none;
            background-color: #F6EFE0;
        }

        .modal-header {
            background-color: #E7D9C2;
            border-radius: 15px 15px 0 0;
            border-bottom: none;
            padding: 20px 30px;
        }

        .modal-title {
            font-weight: bold;
            color: #333;
        }

        .modal-body {
            padding: 30px;
            background-color: #F6EFE0;
        }

        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border: 2px solid #E7D9C2;
            border-radius: 8px;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #d4c5ae;
            box-shadow: 0 0 0 3px rgba(231, 217, 194, 0.2);
        }

        .btn-abrir-mesa {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
        }

        .btn-abrir-mesa:hover {
            background-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn-abrir-mesa:active {
            background-color: #1e7e34;
        }

        .producto-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            background: #F6EFE0;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .producto-item:hover {
            background: #E7D9C2;
        }

        .producto-item:active {
            background: #E7D9C2;
        }

        .producto-info {
            flex: 1;
        }

        .producto-nombre {
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
        }

        .producto-precio {
            color: #666;
            font-size: 14px;
        }

        .cantidad-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cantidad-control button {
            background: #E7D9C2;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .cantidad-control button:hover {
            background: #d4c5ae;
        }

        .cantidad-control button:active {
            background: #d4c5ae;
        }

        .cantidad-control input {
            width: 50px;
            text-align: center;
            border: 2px solid #E7D9C2;
            border-radius: 5px;
            padding: 5px;
        }

        .orden-resumen {
            background: #F6EFE0;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .orden-total {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            padding-top: 15px;
            border-top: 2px solid #E7D9C2;
            margin-top: 15px;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .empty-state i {
            font-size: 60px;
            margin-bottom: 15px;
        }

        .resumen-completo {
            max-height: 400px;
            overflow-y: auto;
            padding: 10px;
        }

        .resumen-item {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            background: #F6EFE0;
            border-radius: 8px;
            margin-bottom: 10px;
            align-items: center;
        }

        .resumen-item-info {
            flex: 1;
        }

        .resumen-item-nombre {
            font-weight: 600;
            color: #333;
            font-size: 16px;
            margin-bottom: 3px;
        }

        .resumen-item-cantidad {
            color: #666;
            font-size: 14px;
        }

        .resumen-item-precio {
            font-weight: bold;
            color: #333;
            font-size: 18px;
        }

        /* Estilos para botones generales */
        .btn-success:active {
            background-color: #1e7e34;
            border-color: #1c7430;
        }

        .btn-secondary:active {
            background-color: #5a6268;
            border-color: #545b62;
        }

        /* Estilos para ordenes del mostrador */
        #ordenes-mostrador-container {
            margin-top: 20px;
        }

        .orden-mostrador-card {
            background: #F6EFE0;
            border: 2px solid #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .orden-mostrador-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .orden-mostrador-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E7D9C2;
        }

        .orden-mostrador-id {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .orden-mostrador-fecha {
            font-size: 14px;
            color: #666;
        }

        .orden-mostrador-productos {
            margin-bottom: 10px;
        }

        .orden-mostrador-producto {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
            color: #333;
        }

        .orden-mostrador-total {
            font-size: 20px;
            font-weight: bold;
            color: #28a745;
            text-align: right;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #E7D9C2;
        }

        .empty-ordenes {
            text-align: center;
            padding: 40px;
            color: #999;
            font-style: italic;
        }

        /* Estilos para tabs de categorias de productos */
        .categorias-tabs {
            margin-bottom: 20px;
        }

        .categorias-tabs .nav-link {
            color: #666;
            border: 2px solid #E7D9C2;
            background: #F6EFE0;
            margin-right: 10px;
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .categorias-tabs .nav-link:hover {
            background: #E7D9C2;
            color: #333;
        }

        .categorias-tabs .nav-link.active {
            background: #28a745;
            color: white;
            border-color: #28a745;
        }

        .productos-lista {
            max-height: 400px;
            overflow-y: auto;
        }

        /* Notificaciones flotantes */
        .toast-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 20px 25px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            z-index: 10000;
            min-width: 300px;
            max-width: 400px;
            animation: slideInRight 0.3s ease-out;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid;
        }

        .toast-notification.success {
            border-left-color: #28a745;
        }

        .toast-notification.error {
            border-left-color: #dc3545;
        }

        .toast-notification.warning {
            border-left-color: #ffc107;
        }

        .toast-notification.info {
            border-left-color: #17a2b8;
        }

        .toast-notification .toast-icon {
            font-size: 28px;
        }

        .toast-notification.success .toast-icon {
            color: #28a745;
        }

        .toast-notification.error .toast-icon {
            color: #dc3545;
        }

        .toast-notification.warning .toast-icon {
            color: #ffc107;
        }

        .toast-notification.info .toast-icon {
            color: #17a2b8;
        }

        .toast-notification .toast-content {
            flex: 1;
        }

        .toast-notification .toast-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
            font-size: 16px;
        }

        .toast-notification .toast-message {
            color: #666;
            font-size: 14px;
        }

        .toast-notification .toast-close {
            background: none;
            border: none;
            font-size: 20px;
            color: #999;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

        .toast-notification .toast-close:hover {
            color: #333;
        }

        @keyframes slideInRight {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }

        .toast-notification.closing {
            animation: slideOutRight 0.3s ease-out forwards;
        }

        /* Modal de confirmación personalizado */
        .custom-confirm-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.2s ease-out;
        }

        .custom-confirm-box {
            background: #F6EFE0;
            border-radius: 15px;
            padding: 30px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: scaleIn 0.3s ease-out;
        }

        .custom-confirm-icon {
            text-align: center;
            font-size: 50px;
            margin-bottom: 20px;
            color: #ffc107;
        }

        .custom-confirm-title {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .custom-confirm-message {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        .custom-confirm-buttons {
            display: flex;
            gap: 10px;
        }

        .custom-confirm-btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .custom-confirm-btn.confirm {
            background: #dc3545;
            color: white;
        }

        .custom-confirm-btn.confirm:hover {
            background: #c82333;
            transform: translateY(-2px);
        }

        .custom-confirm-btn.cancel {
            background: #6c757d;
            color: white;
        }

        .custom-confirm-btn.cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes scaleIn {
            from {
                transform: scale(0.9);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .mensaje-info {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
    </style>

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

            <!-- Tabs Navigation -->
            <asp:HiddenField ID="HdnTabActivo" runat="server" Value="salon" />
            <ul class="nav nav-tabs" id="mesasTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="salon-tab" data-bs-toggle="tab" data-bs-target="#salon" type="button" role="tab" onclick="guardarTab('salon')">
                        <i class="bi bi-house-door"></i> Salon
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="patio-tab" data-bs-toggle="tab" data-bs-target="#patio" type="button" role="tab" onclick="guardarTab('patio')">
                        <i class="bi bi-tree"></i> Patio
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="mostrador-tab" data-bs-toggle="tab" data-bs-target="#mostrador" type="button" role="tab" onclick="guardarTab('mostrador')">
                        <i class="bi bi-shop"></i> Mostrador
                    </button>
                </li>
            </ul>

            <!-- Tabs Content -->
            <div class="tab-content" id="mesasTabContent">
                <!-- Salón Tab -->
                <div class="tab-pane fade show active" id="salon" role="tabpanel">
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
                                    <button type="button" class="delete-btn"
                                        onclick='abrirModalEliminar(<%# Eval("MesaId") %>, "<%# Eval("NumeroMesa") %>", "salon")'>
                                        <i class="bi bi-x"></i>
                                    </button>
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
                <div class="tab-pane fade" id="patio" role="tabpanel">
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
                                    <button type="button" class="delete-btn"
                                        onclick='abrirModalEliminar(<%# Eval("MesaId") %>, "<%# Eval("NumeroMesa") %>", "patio")'>
                                        <i class="bi bi-x"></i>
                                    </button>
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
                <div class="tab-pane fade" id="mostrador" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mostrador</div>
                        <div class="action-buttons">
                            <asp:LinkButton ID="LnkAbrirMostrador" runat="server" CssClass="btn btn-success btn-lg px-5 shadow-sm" OnClick="AbrirMostrador_Click">
                                <i class="bi bi-shop"></i> Abrir Mostrador
                            </asp:LinkButton>
                        </div>
                    </div>
                    <div id="ordenes-mostrador-container">
                        <!-- Ordenes del mostrador se renderizaran aqui -->
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
    <div class="modal fade" id="modalResumenPago" tabindex="-1" aria-labelledby="modalResumenPagoLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalResumenPagoLabel">
                        <i class="bi bi-receipt-cutoff"></i> Resumen de la Cuenta - Mesa <span id="modal-resumen-mesa-numero"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="resumen-completo" id="resumenCompleto">
                        <!-- Se llenara con JavaScript -->
                    </div>

                    <div class="orden-resumen mt-4">
                        <div class="orden-total">
                            <span>Total a Pagar:</span>
                            <span id="totalPagar" style="color: #28a745;">$0</span>
                        </div>
                    </div>

                    <div class="d-flex flex-column gap-3 mt-4">
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-warning flex-fill py-3" style="font-weight: 600; font-size: 16px;" onclick="agregarMasProductos()">
                                <i class="bi bi-plus-circle"></i> Agregar Productos
                            </button>
                        </div>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-success flex-fill py-3" style="font-weight: 600; font-size: 16px;" onclick="procesarPago()">
                                <i class="bi bi-cash-coin"></i> Procesar Pago
                            </button>
                            <button type="button" class="btn btn-secondary flex-fill py-3" style="font-weight: 600; font-size: 16px;" data-bs-dismiss="modal">
                                <i class="bi bi-x-circle"></i> Cancelar
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
                        <i class="bi bi-exclamation-triangle-fill"></i> Confirmar Eliminación
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
        // ========================================
        // FUNCIONES PARA MANEJO DE PRODUCTOS
        // ========================================

        // Cambiar cantidad de un producto
        function cambiarCantidad(boton, incremento, event) {
            event.preventDefault();
            event.stopPropagation();

            const productoItem = boton.closest('.producto-item');
            const input = productoItem.querySelector('input[type="number"]');
            let cantidad = parseInt(input.value) || 0;

            // Actualizar cantidad
            cantidad += incremento;
            if (cantidad < 0) cantidad = 0;

            input.value = cantidad;

            // Actualizar resumen de la orden
            actualizarResumenOrden();
        }

        // Actualizar el resumen de la orden
        function actualizarResumenOrden() {
            const resumenDiv = document.getElementById('resumenOrden');
            const totalSpan = document.getElementById('totalOrden');

            // Obtener todos los productos con cantidad > 0
            const todosProductos = document.querySelectorAll('.producto-item');
            const productosSeleccionados = [];

            todosProductos.forEach(producto => {
                const input = producto.querySelector('input[type="number"]');
                const cantidad = parseInt(input.value) || 0;

                if (cantidad > 0) {
                    const nombre = producto.getAttribute('data-nombre');
                    const precio = parseFloat(producto.getAttribute('data-precio'));
                    const productoId = producto.getAttribute('data-productoid');

                    productosSeleccionados.push({
                        id: productoId,
                        nombre: nombre,
                        precio: precio,
                        cantidad: cantidad,
                        subtotal: precio * cantidad
                    });
                }
            });

            // Actualizar HTML del resumen
            if (productosSeleccionados.length === 0) {
                resumenDiv.innerHTML = '<p style="color: #999; font-style: italic;">No hay productos seleccionados</p>';
                totalSpan.textContent = '$0';
            } else {
                let html = '<div style="max-height: 200px; overflow-y: auto;">';
                let total = 0;

                productosSeleccionados.forEach(prod => {
                    total += prod.subtotal;
                    html += `
                        <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee;">
                            <div>
                                <strong>${prod.nombre}</strong>
                                <span style="color: #666; font-size: 14px;"> x${prod.cantidad}</span>
                            </div>
                            <div style="font-weight: 600;">$${prod.subtotal.toLocaleString('es-AR', {minimumFractionDigits: 0, maximumFractionDigits: 0})}</div>
                        </div>
                    `;
                });

                html += '</div>';
                resumenDiv.innerHTML = html;
                totalSpan.textContent = '$' + total.toLocaleString('es-AR', {minimumFractionDigits: 0, maximumFractionDigits: 0});
            }
        }

        // Confirmar orden
        function confirmarOrden() {
            const todosProductos = document.querySelectorAll('.producto-item');
            let hayProductos = false;

            todosProductos.forEach(producto => {
                const input = producto.querySelector('input[type="number"]');
                const cantidad = parseInt(input.value) || 0;
                if (cantidad > 0) {
                    hayProductos = true;
                }
            });

            if (!hayProductos) {
                alert('Por favor selecciona al menos un producto');
                return;
            }

            // TODO: Aquí se debe guardar el pedido en la base de datos
            alert('Funcionalidad de confirmar orden pendiente de implementar');
        }

        function abrirModalEliminar(mesaId, numeroMesa, ubicacion) {
            document.getElementById('<%= HdnMesaIdEliminar.ClientID %>').value = mesaId;
            document.getElementById('<%= HdnMesaNumeroEliminar.ClientID %>').value = numeroMesa;
            document.getElementById('<%= HdnMesaUbicacionEliminar.ClientID %>').value = ubicacion;

            document.getElementById('modalEliminarNumero').textContent = numeroMesa;

            var modal = new bootstrap.Modal(document.getElementById('modalEliminarMesa'));
            modal.show();
        }

        function guardarTab(tab) {
            var hdnTabActivo = document.getElementById('<%= HdnTabActivo.ClientID %>');
            if (hdnTabActivo) {
                hdnTabActivo.value = tab;
            }
        }

        // Restaurar tab activo después del PostBack
        function restaurarTab() {
            var hdnTabActivo = document.getElementById('<%= HdnTabActivo.ClientID %>');
            if (hdnTabActivo && hdnTabActivo.value) {
                var tabActivo = hdnTabActivo.value;

                // Remover clase active de todos los tabs
                document.querySelectorAll('#mesasTabs .nav-link').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('#mesasTabContent .tab-pane').forEach(p => {
                    p.classList.remove('show', 'active');
                });

                // Activar el tab correcto
                var tabBtn = document.getElementById(tabActivo + '-tab');
                var tabPane = document.getElementById(tabActivo);

                if (tabBtn && tabPane) {
                    tabBtn.classList.add('active');
                    tabPane.classList.add('show', 'active');
                }
            }
        }

        // Manejar Enter en el textbox de búsqueda
        function handleEnterBusqueda(event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                // Hacer PostBack del TextBox para ejecutar búsqueda
                __doPostBack('<%= TxtBuscarProducto.UniqueID %>', '');
                return false;
            }
            return true;
        }

        // Mantener foco en el textbox después del PostBack
        var Sys = Sys || {};
        Sys.WebForms = Sys.WebForms || {};
        Sys.WebForms.PageRequestManager = Sys.WebForms.PageRequestManager || {};

        function mantenerFocoEnBusqueda() {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            if (prm) {
                prm.add_endRequest(function (sender, args) {
                    // Después del PostBack, devolver el foco al textbox
                    var txtBuscar = document.getElementById('<%= TxtBuscarProducto.ClientID %>');
                    if (txtBuscar) {
                        setTimeout(function() {
                            txtBuscar.focus();
                            // Colocar cursor al final del texto
                            var len = txtBuscar.value.length;
                            if (txtBuscar.setSelectionRange) {
                                txtBuscar.setSelectionRange(len, len);
                            }
                        }, 100);
                    }
                });
            }
        }

        // Limpiar búsqueda al cerrar modal
        function limpiarBusquedaAlCerrarModal() {
            var txtBuscar = document.getElementById('<%= TxtBuscarProducto.ClientID %>');
            if (txtBuscar && txtBuscar.value.trim()) {
                // Hacer click en el botón de limpiar
                var btnLimpiar = document.getElementById('<%= BtnLimpiarBusqueda.ClientID %>');
                if (btnLimpiar && btnLimpiar.style.display !== 'none') {
                    btnLimpiar.click();
                }
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            // Restaurar tab activo
            restaurarTab();

            // Inicializar mantener foco en búsqueda después de UpdatePanel
            mantenerFocoEnBusqueda();

            // Agregar evento al cerrar modal de orden
            const modalOrden = document.getElementById('modalOrden');
            if (modalOrden) {
                modalOrden.addEventListener('hidden.bs.modal', limpiarBusquedaAlCerrarModal);
            }
        });
    </script>
</asp:Content>
