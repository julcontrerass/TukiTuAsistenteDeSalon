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
        }

        .mesa-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }

        .mesa-card .mesa-icon {
            font-size: 50px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .mesa-card.libre .mesa-icon {
            color: #28a745;
        }

        .mesa-card.ocupada .mesa-icon {
            color: #dc3545;
        }

        .mesa-card .mesa-number {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .mesa-card .mesa-status {
            font-size: 14px;
            color: #666;
        }

        .mesa-card .delete-btn {
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
            display: none;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .mesa-card:hover .delete-btn {
            display: flex;
        }

        .delete-btn:hover {
            background: #c82333;
            transform: scale(1.1);
        }

        .add-mesa-card {
            background: #F6EFE0;
            border: 2px dashed #E7D9C2;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 140px;
        }

        .add-mesa-card:hover {
            background: #E7D9C2;
            border-color: #d4c5ae;
        }

        .add-mesa-card i {
            font-size: 40px;
            color: #666;
            margin-bottom: 10px;
        }

        .add-mesa-card span {
            font-size: 14px;
            color: #666;
            font-weight: 600;
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
    </style>

    <div class="mesas-container">
        <div class="tabs-container">
            <h2 class="mb-4" style="color: #333; font-weight: bold;">
                <i class="bi bi-grid-3x3"></i> Gestion de Mesas
            </h2>

            <!-- Tabs Navigation -->
            <ul class="nav nav-tabs" id="mesasTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="salon-tab" data-bs-toggle="tab" data-bs-target="#salon" type="button" role="tab">
                        <i class="bi bi-house-door"></i> Salon
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="patio-tab" data-bs-toggle="tab" data-bs-target="#patio" type="button" role="tab">
                        <i class="bi bi-tree"></i> Patio
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="mostrador-tab" data-bs-toggle="tab" data-bs-target="#mostrador" type="button" role="tab">
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
                        <div class="action-buttons">
                            <button type="button" class="btn btn-success px-4 shadow-sm" onclick="agregarMesa('salon')">
                                <i class="bi bi-plus-circle"></i> Agregar Mesa
                            </button>
                        </div>
                    </div>
                    <div class="mesas-grid" id="mesas-salon">
                        <!-- Mesas del salon se generaran dinamicamente -->
                    </div>
                </div>

                <!-- Patio Tab -->
                <div class="tab-pane fade" id="patio" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mesas del Patio</div>
                        <div class="action-buttons">
                            <button type="button" class="btn btn-success px-4 shadow-sm" onclick="agregarMesa('patio')">
                                <i class="bi bi-plus-circle"></i> Agregar Mesa
                            </button>
                        </div>
                    </div>
                    <div class="mesas-grid" id="mesas-patio">
                        <!-- Mesas del patio se generaran dinamicamente -->
                    </div>
                </div>

                <!-- Mostrador Tab -->
                <div class="tab-pane fade" id="mostrador" role="tabpanel">
                    <div class="section-header">
                        <div class="section-title">Mostrador</div>
                        <div class="action-buttons">
                            <button type="button" class="btn btn-success btn-lg px-5 shadow-sm" onclick="abrirMostrador()">
                                Abrir Mostrador
                            </button>
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
                        <i class="bi bi-octagon-fill"></i> Mesa <span id="modal-mesa-numero"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="cantidadPersonas" class="form-label">
                            <i class="bi bi-people-fill"></i> Cantidad de Personas
                        </label>
                        <input type="number" class="form-control" id="cantidadPersonas" min="1" value="1" placeholder="Ingrese cantidad de personas">
                    </div>
                    <div class="mb-4">
                        <label for="selectCamarero" class="form-label">
                            <i class="bi bi-person-badge"></i> Camarero Asignado
                        </label>
                        <select class="form-select" id="selectCamarero">
                            <option value="">Seleccione un camarero</option>
                            <option value="Juan Perez">Juan Perez</option>
                            <option value="Maria Gonzalez">Maria Gonzalez</option>
                            <option value="Carlos Rodriguez">Carlos Rodriguez</option>
                            <option value="Ana Martinez">Ana Martinez</option>
                            <option value="Luis Fernandez">Luis Fernandez</option>
                        </select>
                    </div>
                    <button type="button" class="btn-abrir-mesa" onclick="confirmarAbrirMesa()">
                        <i class="bi bi-check-circle-fill"></i> Abrir Mesa
                    </button>
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
                    <div class="mb-3">
                        <label class="form-label">
                            <i class="bi bi-search"></i> Buscar Producto
                        </label>
                        <input type="text" class="form-control" id="buscarProducto" placeholder="Buscar producto...">
                    </div>

                    <div class="productos-lista" id="productosLista">
                        <!-- Productos de ejemplo -->
                        <div class="producto-item" data-nombre="Hamburguesa Clasica" data-precio="1500">
                            <div class="producto-info">
                                <div class="producto-nombre">Hamburguesa Clasica</div>
                                <div class="producto-precio">$1,500</div>
                            </div>
                            <div class="cantidad-control">
                                <button type="button" onclick="cambiarCantidad(this, -1, event)">-</button>
                                <input type="number" value="0" min="0" readonly>
                                <button type="button" onclick="cambiarCantidad(this, 1, event)">+</button>
                            </div>
                        </div>

                        <div class="producto-item" data-nombre="Pizza Margarita" data-precio="2000">
                            <div class="producto-info">
                                <div class="producto-nombre">Pizza Margarita</div>
                                <div class="producto-precio">$2,000</div>
                            </div>
                            <div class="cantidad-control">
                                <button type="button" onclick="cambiarCantidad(this, -1, event)">-</button>
                                <input type="number" value="0" min="0" readonly>
                                <button type="button" onclick="cambiarCantidad(this, 1, event)">+</button>
                            </div>
                        </div>

                        <div class="producto-item" data-nombre="Ensalada Cesar" data-precio="1200">
                            <div class="producto-info">
                                <div class="producto-nombre">Ensalada Cesar</div>
                                <div class="producto-precio">$1,200</div>
                            </div>
                            <div class="cantidad-control">
                                <button type="button" onclick="cambiarCantidad(this, -1, event)">-</button>
                                <input type="number" value="0" min="0" readonly>
                                <button type="button" onclick="cambiarCantidad(this, 1, event)">+</button>
                            </div>
                        </div>

                        <div class="producto-item" data-nombre="Coca Cola" data-precio="500">
                            <div class="producto-info">
                                <div class="producto-nombre">Coca Cola</div>
                                <div class="producto-precio">$500</div>
                            </div>
                            <div class="cantidad-control">
                                <button type="button" onclick="cambiarCantidad(this, -1, event)">-</button>
                                <input type="number" value="0" min="0" readonly>
                                <button type="button" onclick="cambiarCantidad(this, 1, event)">+</button>
                            </div>
                        </div>

                        <div class="producto-item" data-nombre="Cafe Americano" data-precio="300">
                            <div class="producto-info">
                                <div class="producto-nombre">Cafe Americano</div>
                                <div class="producto-precio">$300</div>
                            </div>
                            <div class="cantidad-control">
                                <button type="button" onclick="cambiarCantidad(this, -1, event)">-</button>
                                <input type="number" value="0" min="0" readonly>
                                <button type="button" onclick="cambiarCantidad(this, 1, event)">+</button>
                            </div>
                        </div>
                    </div>

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

    <script>
        // Datos de las mesas
        let mesasData = {
            salon: [],
            patio: []
        };

        // Ordenes del mostrador
        let ordenesMostrador = [];

        // Mesa actual seleccionada
        let mesaActual = null;

        // Orden temporal (para editar antes de confirmar)
        let ordenTemporal = [];

        // Inicializar mesas de ejemplo
        function inicializarMesas() {
            // Mesas del salon
            for (let i = 1; i <= 8; i++) {
                mesasData.salon.push({
                    numero: i,
                    estado: 'libre',
                    seccion: 'salon',
                    orden: null, // null = no hay orden confirmada
                    cantidadPersonas: 0,
                    camarero: ''
                });
            }

            // Mesas del patio
            for (let i = 1; i <= 6; i++) {
                mesasData.patio.push({
                    numero: i,
                    estado: 'libre',
                    seccion: 'patio',
                    orden: null,
                    cantidadPersonas: 0,
                    camarero: ''
                });
            }

            renderizarMesas();
        }

        // Renderizar mesas en el DOM
        function renderizarMesas() {
            renderizarSeccion('salon');
            renderizarSeccion('patio');
        }

        function renderizarSeccion(seccion) {
            const container = document.getElementById('mesas-' + seccion);
            container.innerHTML = '';

            mesasData[seccion].forEach(mesa => {
                const mesaCard = document.createElement('div');
                mesaCard.className = 'mesa-card ' + mesa.estado;
                mesaCard.innerHTML = `
                    <button class="delete-btn" onclick="event.stopPropagation(); eliminarMesa('${seccion}', ${mesa.numero})">
                        <i class="bi bi-x"></i>
                    </button>
                    <i class="bi bi-octagon-fill mesa-icon"></i>
                    <div class="mesa-number">Mesa ${mesa.numero}</div>
                    <div class="mesa-status">${mesa.estado === 'libre' ? 'Libre' : 'Ocupada'}</div>
                `;
                mesaCard.onclick = function() { seleccionarMesa(seccion, mesa.numero); };
                container.appendChild(mesaCard);
            });
        }

        // Seleccionar una mesa
        function seleccionarMesa(seccion, numero) {
            const mesa = mesasData[seccion].find(m => m.numero === numero);
            if (!mesa) return;

            mesaActual = { seccion, numero };

            if (mesa.estado === 'libre') {
                // Abrir modal para abrir la mesa
                document.getElementById('modal-mesa-numero').textContent = numero;
                document.getElementById('cantidadPersonas').value = 1;
                document.getElementById('selectCamarero').value = '';
                const modal = new bootstrap.Modal(document.getElementById('modalAbrirMesa'));
                modal.show();
            } else if (mesa.orden) {
                // Si ya tiene orden confirmada, abrir modal de resumen
                abrirModalResumenPago(mesa.orden);
            } else {
                // Si esta ocupada pero sin orden confirmada, abrir modal de orden
                abrirModalOrden(numero);
            }
        }

        // Confirmar abrir mesa
        function confirmarAbrirMesa() {
            const cantidadPersonas = document.getElementById('cantidadPersonas').value;
            const camarero = document.getElementById('selectCamarero').value;

            if (!cantidadPersonas || cantidadPersonas < 1) {
                alert('Por favor ingrese la cantidad de personas');
                return;
            }

            if (!camarero) {
                alert('Por favor seleccione un camarero');
                return;
            }

            // Cambiar estado de la mesa
            const mesa = mesasData[mesaActual.seccion].find(m => m.numero === mesaActual.numero);
            if (mesa) {
                mesa.estado = 'ocupada';
                mesa.cantidadPersonas = cantidadPersonas;
                mesa.camarero = camarero;
                renderizarSeccion(mesaActual.seccion);
            }

            // Cerrar modal de abrir mesa
            const modalAbrirMesa = bootstrap.Modal.getInstance(document.getElementById('modalAbrirMesa'));
            modalAbrirMesa.hide();

            // Abrir modal de orden
            setTimeout(() => {
                abrirModalOrden(mesaActual.numero);
            }, 300);
        }

        // Abrir modal de orden
        function abrirModalOrden(numero) {
            document.getElementById('modal-orden-mesa-numero').textContent = numero;

            // Resetear cantidades
            document.querySelectorAll('.cantidad-control input').forEach(input => {
                input.value = 0;
            });
            actualizarResumenOrden();

            const modal = new bootstrap.Modal(document.getElementById('modalOrden'));
            modal.show();
        }

        // Abrir mostrador
        function abrirMostrador() {
            mesaActual = { seccion: 'mostrador', numero: 0 };
            abrirModalOrden('Mostrador');
        }

        // Cambiar cantidad de producto
        function cambiarCantidad(button, cambio, event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            const input = button.parentElement.querySelector('input');
            let cantidad = parseInt(input.value) || 0;
            cantidad = Math.max(0, cantidad + cambio);
            input.value = cantidad;
            actualizarResumenOrden();
        }

        // Actualizar resumen de orden
        function actualizarResumenOrden() {
            const resumenDiv = document.getElementById('resumenOrden');
            const totalSpan = document.getElementById('totalOrden');
            let html = '';
            let total = 0;

            document.querySelectorAll('.producto-item').forEach(item => {
                const cantidad = parseInt(item.querySelector('.cantidad-control input').value);
                if (cantidad > 0) {
                    const nombre = item.dataset.nombre;
                    const precio = parseInt(item.dataset.precio);
                    const subtotal = precio * cantidad;
                    total += subtotal;

                    html += `
                        <div style="display: flex; justify-content: space-between; margin-bottom: 8px; color: #333;">
                            <span>${cantidad}x ${nombre}</span>
                            <span style="font-weight: 600;">$${subtotal.toLocaleString()}</span>
                        </div>
                    `;
                }
            });

            if (html === '') {
                resumenDiv.innerHTML = '<p style="color: #999; font-style: italic;">No hay productos seleccionados</p>';
            } else {
                resumenDiv.innerHTML = html;
            }

            totalSpan.textContent = '$' + total.toLocaleString();
        }

        // Confirmar orden
        function confirmarOrden() {
            const productos = [];
            document.querySelectorAll('.producto-item').forEach(item => {
                const cantidad = parseInt(item.querySelector('.cantidad-control input').value);
                if (cantidad > 0) {
                    productos.push({
                        nombre: item.dataset.nombre,
                        cantidad: cantidad,
                        precio: parseInt(item.dataset.precio)
                    });
                }
            });

            if (productos.length === 0) {
                alert('Por favor seleccione al menos un producto');
                return;
            }

            // Guardar orden en la mesa o mostrador
            if (mesaActual.seccion === 'mostrador') {
                // Agregar orden al mostrador
                const ordenId = Date.now();
                ordenesMostrador.push({
                    id: ordenId,
                    productos: productos,
                    fecha: new Date(),
                    estado: 'activa'
                });
                mesaActual.ordenId = ordenId;
                renderizarOrdenesMostrador();
            } else {
                // Guardar orden en la mesa
                const mesa = mesasData[mesaActual.seccion].find(m => m.numero === mesaActual.numero);
                if (mesa) {
                    mesa.orden = productos;
                }
            }

            // Cerrar modal de orden
            const modalOrden = bootstrap.Modal.getInstance(document.getElementById('modalOrden'));
            modalOrden.hide();

            // Esperar un poco y abrir modal de resumen y pago
            setTimeout(() => {
                abrirModalResumenPago(productos);
            }, 300);
        }

        // Abrir modal de resumen y pago
        function abrirModalResumenPago(productos) {
            const mesaNumero = document.getElementById('modal-orden-mesa-numero').textContent;
            document.getElementById('modal-resumen-mesa-numero').textContent = mesaNumero;

            const resumenDiv = document.getElementById('resumenCompleto');
            const totalSpan = document.getElementById('totalPagar');

            let html = '';
            let total = 0;

            productos.forEach(producto => {
                const subtotal = producto.cantidad * producto.precio;
                total += subtotal;

                html += `
                    <div class="resumen-item">
                        <div class="resumen-item-info">
                            <div class="resumen-item-nombre">${producto.nombre}</div>
                            <div class="resumen-item-cantidad">Cantidad: ${producto.cantidad} x $${producto.precio.toLocaleString()}</div>
                        </div>
                        <div class="resumen-item-precio">$${subtotal.toLocaleString()}</div>
                    </div>
                `;
            });

            resumenDiv.innerHTML = html;
            totalSpan.textContent = '$' + total.toLocaleString();

            const modal = new bootstrap.Modal(document.getElementById('modalResumenPago'));
            modal.show();
        }

        // Procesar pago
        function procesarPago() {
            // Aqui se procesaria el pago
            alert('Pago procesado exitosamente!');

            // Si es una mesa, cambiar su estado a libre y limpiar orden
            if (mesaActual && mesaActual.seccion !== 'mostrador') {
                const mesa = mesasData[mesaActual.seccion].find(m => m.numero === mesaActual.numero);
                if (mesa) {
                    mesa.estado = 'libre';
                    mesa.orden = null;
                    mesa.cantidadPersonas = 0;
                    mesa.camarero = '';
                    renderizarSeccion(mesaActual.seccion);
                }
            } else {
                // Si es mostrador, remover la orden de la lista
                const mesaNumero = document.getElementById('modal-resumen-mesa-numero').textContent;
                if (mesaNumero === 'Mostrador' && ordenesMostrador.length > 0) {
                    // Encontrar y eliminar la orden actual por sus productos
                    const modalResumen = document.getElementById('resumenCompleto');
                    ordenesMostrador = ordenesMostrador.filter(orden => orden.estado === 'pagada' || orden.id !== mesaActual.ordenId);
                }
                renderizarOrdenesMostrador();
            }

            // Cerrar modal
            const modalResumenPago = bootstrap.Modal.getInstance(document.getElementById('modalResumenPago'));
            modalResumenPago.hide();
        }

        // Agregar mas productos a la orden existente
        function agregarMasProductos() {
            // Obtener la orden actual
            let ordenActual = [];

            if (mesaActual.seccion === 'mostrador') {
                const orden = ordenesMostrador.find(o => o.id === mesaActual.ordenId);
                if (orden) {
                    ordenActual = orden.productos;
                }
            } else {
                const mesa = mesasData[mesaActual.seccion].find(m => m.numero === mesaActual.numero);
                if (mesa && mesa.orden) {
                    ordenActual = mesa.orden;
                }
            }

            // Cerrar modal de resumen
            const modalResumenPago = bootstrap.Modal.getInstance(document.getElementById('modalResumenPago'));
            modalResumenPago.hide();

            // Abrir modal de orden con los productos precargados
            setTimeout(() => {
                const mesaNumero = document.getElementById('modal-resumen-mesa-numero').textContent;
                abrirModalOrdenConProductos(mesaNumero, ordenActual);
            }, 300);
        }

        // Abrir modal de orden con productos precargados
        function abrirModalOrdenConProductos(numero, productosExistentes) {
            document.getElementById('modal-orden-mesa-numero').textContent = numero;

            // Resetear todas las cantidades primero
            document.querySelectorAll('.cantidad-control input').forEach(input => {
                input.value = 0;
            });

            // Precargar los productos existentes
            productosExistentes.forEach(prod => {
                document.querySelectorAll('.producto-item').forEach(item => {
                    if (item.dataset.nombre === prod.nombre) {
                        item.querySelector('.cantidad-control input').value = prod.cantidad;
                    }
                });
            });

            actualizarResumenOrden();

            const modal = new bootstrap.Modal(document.getElementById('modalOrden'));
            modal.show();
        }

        // Agregar nueva mesa
        function agregarMesa(seccion) {
            const maxNumero = mesasData[seccion].length > 0
                ? Math.max(...mesasData[seccion].map(m => m.numero))
                : 0;

            mesasData[seccion].push({
                numero: maxNumero + 1,
                estado: 'libre',
                seccion: seccion
            });

            renderizarSeccion(seccion);
        }

        // Eliminar mesa
        function eliminarMesa(seccion, numero) {
            if (confirm(`Esta seguro que desea eliminar la Mesa ${numero}?`)) {
                mesasData[seccion] = mesasData[seccion].filter(m => m.numero !== numero);
                renderizarSeccion(seccion);
            }
        }

        // Renderizar ordenes del mostrador
        function renderizarOrdenesMostrador() {
            const container = document.getElementById('ordenes-mostrador-container');

            if (ordenesMostrador.length === 0) {
                container.innerHTML = '<div class="empty-ordenes">No hay ordenes activas en el mostrador</div>';
                return;
            }

            let html = '<h4 style="color: #333; margin-bottom: 20px; font-weight: bold;">Ordenes Activas</h4>';

            ordenesMostrador.forEach(orden => {
                if (orden.estado === 'activa') {
                    let total = 0;
                    let productosHtml = '';

                    orden.productos.forEach(prod => {
                        const subtotal = prod.cantidad * prod.precio;
                        total += subtotal;
                        productosHtml += `
                            <div class="orden-mostrador-producto">
                                <span>${prod.cantidad}x ${prod.nombre}</span>
                                <span>$${subtotal.toLocaleString()}</span>
                            </div>
                        `;
                    });

                    const fechaFormato = new Date(orden.fecha).toLocaleTimeString('es-ES', {
                        hour: '2-digit',
                        minute: '2-digit'
                    });

                    html += `
                        <div class="orden-mostrador-card" onclick="verOrdenMostrador(${orden.id})">
                            <div class="orden-mostrador-header">
                                <div class="orden-mostrador-id">
                                    <i class="bi bi-receipt"></i> Orden #${orden.id.toString().slice(-6)}
                                </div>
                                <div class="orden-mostrador-fecha">
                                    <i class="bi bi-clock"></i> ${fechaFormato}
                                </div>
                            </div>
                            <div class="orden-mostrador-productos">
                                ${productosHtml}
                            </div>
                            <div class="orden-mostrador-total">
                                Total: $${total.toLocaleString()}
                            </div>
                        </div>
                    `;
                }
            });

            container.innerHTML = html;
        }

        // Ver orden del mostrador
        function verOrdenMostrador(ordenId) {
            const orden = ordenesMostrador.find(o => o.id === ordenId);
            if (!orden) return;

            mesaActual = { seccion: 'mostrador', numero: 0, ordenId: ordenId };
            abrirModalResumenPago(orden.productos);
        }

        // Busqueda de productos
        document.addEventListener('DOMContentLoaded', function() {
            inicializarMesas();

            const buscarInput = document.getElementById('buscarProducto');
            if (buscarInput) {
                buscarInput.addEventListener('input', function(e) {
                    const texto = e.target.value.toLowerCase();
                    document.querySelectorAll('.producto-item').forEach(item => {
                        const nombre = item.dataset.nombre.toLowerCase();
                        if (nombre.includes(texto)) {
                            item.style.display = 'flex';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            }
        });
    </script>
</asp:Content>
