// ===== VARIABLES GLOBALES =====
let draggedElement = null;
let offsetX = 0;
let offsetY = 0;
let canvasRect = null;
let editModeActive = { salon: false, patio: false };
let originalPositions = { salon: {}, patio: {} };
let currentX = 0;
let currentY = 0;
let isDragging = false;

// ===== FUNCIONES DE UTILIDAD =====
const formatearPrecio = (num) => '$' + Math.round(num).toLocaleString('es-AR');

// ===== DRAG & DROP PARA MESAS =====
function initDragDrop() {
    const canvases = document.querySelectorAll('.mesas-canvas');

    canvases.forEach(canvas => {
        const mesas = canvas.querySelectorAll('.mesa-container');

        mesas.forEach(mesa => {
            // Remover event listeners existentes para evitar duplicados
            mesa.removeEventListener('mousedown', startDrag);
            mesa.removeEventListener('touchstart', startDrag);

            // Mouse events
            mesa.addEventListener('mousedown', startDrag, { passive: false });

            // Touch events
            mesa.addEventListener('touchstart', startDrag, { passive: false });
        });
    });

    // Global events (solo una vez)
    document.removeEventListener('mousemove', drag);
    document.removeEventListener('mouseup', endDrag);
    document.removeEventListener('touchmove', drag);
    document.removeEventListener('touchend', endDrag);

    document.addEventListener('mousemove', drag, { passive: false });
    document.addEventListener('mouseup', endDrag);
    document.addEventListener('touchmove', drag, { passive: false });
    document.addEventListener('touchend', endDrag);
}

function startDrag(e) {
    // No arrastrar si se hace clic en el botón de eliminar
    if (e.target.closest('.delete-btn') || e.target.classList.contains('delete-btn')) {
        return;
    }

    const mesa = e.currentTarget;
    const canvas = mesa.closest('.mesas-canvas');

    if (!canvas) return;

    const ubicacion = canvas.getAttribute('data-ubicacion');

    // IMPORTANTE: Solo permitir drag en modo edición
    if (!editModeActive[ubicacion]) {
        return;
    }

    e.preventDefault();

    draggedElement = mesa;
    canvasRect = canvas.getBoundingClientRect();
    isDragging = true;

    const clientX = e.type === 'touchstart' ? e.touches[0].clientX : e.clientX;
    const clientY = e.type === 'touchstart' ? e.touches[0].clientY : e.clientY;
    const mesaRect = mesa.getBoundingClientRect();

    offsetX = clientX - mesaRect.left;
    offsetY = clientY - mesaRect.top;

    mesa.classList.add('dragging');
    mesa.style.willChange = 'transform';
}

function drag(e) {
    if (!draggedElement || !canvasRect || !isDragging) return;

    e.preventDefault();

    const clientX = e.type === 'touchmove' ? e.touches[0].clientX : e.clientX;
    const clientY = e.type === 'touchmove' ? e.touches[0].clientY : e.clientY;

    const canvas = draggedElement.closest('.mesas-canvas');
    if (!canvas) return;

    // Calcular nueva posición relativa al canvas incluyendo scroll
    currentX = clientX - canvasRect.left - offsetX + canvas.scrollLeft;
    currentY = clientY - canvasRect.top - offsetY + canvas.scrollTop;

    // Limitar a los bordes del canvas
    const mesaWidth = draggedElement.offsetWidth;
    const mesaHeight = draggedElement.offsetHeight;

    currentX = Math.max(0, Math.min(currentX, canvas.scrollWidth - mesaWidth));
    currentY = Math.max(0, Math.min(currentY, canvas.scrollHeight - mesaHeight));

    // Aplicar posición inmediatamente sin requestAnimationFrame para mayor fluidez
    draggedElement.style.left = currentX + 'px';
    draggedElement.style.top = currentY + 'px';
}

function endDrag(e) {
    if (!draggedElement) return;

    isDragging = false;
    draggedElement.classList.remove('dragging');
    draggedElement.style.willChange = 'auto';

    draggedElement = null;
    canvasRect = null;
}

// ===== MODO EDICION =====
function toggleEditMode(ubicacion) {
    const canvas = document.querySelector(`.mesas-canvas[data-ubicacion="${ubicacion}"]`);
    const btnEdit = document.querySelector(`.btn-edit-mode[data-ubicacion="${ubicacion}"]`);
    const btnSave = document.querySelector(`.btn-save-mode[data-ubicacion="${ubicacion}"]`);
    const btnCancel = document.querySelector(`.btn-cancel-mode[data-ubicacion="${ubicacion}"]`);

    if (!canvas) return;

    // Activar modo edicion
    editModeActive[ubicacion] = true;
    canvas.classList.add('edit-mode');

    // Guardar posiciones originales por si se cancela
    saveOriginalPositions(ubicacion);

    // Cambiar botones
    btnEdit.style.display = 'none';
    btnSave.style.display = 'inline-block';
    btnCancel.style.display = 'inline-block';
}

function savePositions(ubicacion) {
    const canvas = document.querySelector(`.mesas-canvas[data-ubicacion="${ubicacion}"]`);
    if (!canvas) return;

    // Recolectar posiciones actuales
    const positions = {};
    positions[ubicacion] = [];

    const mesas = canvas.querySelectorAll('.mesa-container');
    mesas.forEach(mesa => {
        const mesaId = mesa.getAttribute('data-mesa-id');
        const x = parseInt(mesa.style.left) || 0;
        const y = parseInt(mesa.style.top) || 0;

        if (mesaId) {
            positions[ubicacion].push({
                mesaId: mesaId,
                x: x,
                y: y
            });
        }
    });

    // Guardar en campo oculto
    const hdnField = document.getElementById(window.hdnPosicionesMesasId);
    if (hdnField) {
        hdnField.value = JSON.stringify(positions);
    }

    // Guardar ubicacion actual para mantener el tab activo
    const hdnTabActivo = document.getElementById(window.hdnTabActivoId);
    if (hdnTabActivo) {
        hdnTabActivo.value = ubicacion;
    }

    // Hacer postback para guardar en BD
    __doPostBack('', 'SavePositions');
}

function cancelEditMode(ubicacion) {
    const canvas = document.querySelector(`.mesas-canvas[data-ubicacion="${ubicacion}"]`);
    const btnEdit = document.querySelector(`.btn-edit-mode[data-ubicacion="${ubicacion}"]`);
    const btnSave = document.querySelector(`.btn-save-mode[data-ubicacion="${ubicacion}"]`);
    const btnCancel = document.querySelector(`.btn-cancel-mode[data-ubicacion="${ubicacion}"]`);

    if (!canvas) return;

    // Restaurar posiciones originales
    restoreOriginalPositions(ubicacion);

    // Desactivar modo edicion
    editModeActive[ubicacion] = false;
    canvas.classList.remove('edit-mode');

    // Cambiar botones
    btnEdit.style.display = 'inline-block';
    btnSave.style.display = 'none';
    btnCancel.style.display = 'none';
}

function saveOriginalPositions(ubicacion) {
    const canvas = document.querySelector(`.mesas-canvas[data-ubicacion="${ubicacion}"]`);
    if (!canvas) return;

    originalPositions[ubicacion] = {};
    const mesas = canvas.querySelectorAll('.mesa-container');
    mesas.forEach(mesa => {
        const mesaId = mesa.getAttribute('data-mesa-id');
        if (mesaId) {
            originalPositions[ubicacion][mesaId] = {
                x: parseInt(mesa.style.left) || 0,
                y: parseInt(mesa.style.top) || 0
            };
        }
    });
}

function restoreOriginalPositions(ubicacion) {
    const canvas = document.querySelector(`.mesas-canvas[data-ubicacion="${ubicacion}"]`);
    if (!canvas || !originalPositions[ubicacion]) return;

    const mesas = canvas.querySelectorAll('.mesa-container');
    mesas.forEach(mesa => {
        const mesaId = mesa.getAttribute('data-mesa-id');
        if (mesaId && originalPositions[ubicacion][mesaId]) {
            const pos = originalPositions[ubicacion][mesaId];
            mesa.style.left = pos.x + 'px';
            mesa.style.top = pos.y + 'px';
        }
    });
}

function handleMesaClick(element, ubicacion) {
    // Si esta en modo edicion, NO abrir la orden
    if (editModeActive[ubicacion]) {
        return false; // Prevenir postback
    }
    // Si NO esta en modo edicion, permitir abrir la orden
    return true; // Permitir postback
}

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

    document.getElementById(window.hdnProductosOrdenId).value = JSON.stringify(productos);
    window.postbackConfirmarOrden();
}

// ===== BÚSQUEDA =====
function handleEnterBusqueda(event) {
    if (event.keyCode === 13) {
        event.preventDefault();
        __doPostBack(window.txtBuscarProductoUniqueId, '');
        return false;
    }
    return true;
}

function mantenerFocoEnBusqueda() {
    const prm = Sys?.WebForms?.PageRequestManager?.getInstance();
    if (prm) {
        prm.add_endRequest(() => {
            const txtBuscar = document.getElementById(window.txtBuscarProductoId);
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
    const txtBuscar = document.getElementById(window.txtBuscarProductoId);
    const btnLimpiar = document.getElementById(window.btnLimpiarBusquedaId);
    if (txtBuscar?.value.trim() && btnLimpiar?.style.display !== 'none') {
        btnLimpiar.click();
    }
}

// ===== FUNCIONES PARA MODAL DE PAGO =====
function toggleMontoRecibido() {
    const divMontoRecibido = document.getElementById('divMontoRecibido');
    const divVuelto = document.getElementById('divVuelto');
    const radioEfectivo = document.getElementById('radioEfectivo');

    if (radioEfectivo.checked) {
        divMontoRecibido.style.display = 'block';
        calcularVuelto();
    } else {
        divMontoRecibido.style.display = 'none';
        divVuelto.style.display = 'none';
    }
}

function calcularVuelto() {
    const totalPagar = parseFloat(document.getElementById('modal-pago-total').textContent.replace('$', '').replace(/\./g, '').replace(',', '.')) || 0;
    const montoRecibido = parseFloat(document.getElementById('txtMontoRecibido').value) || 0;
    const divVuelto = document.getElementById('divVuelto');
    const spanVuelto = document.getElementById('spanVuelto');

    if (montoRecibido > 0) {
        const vuelto = montoRecibido - totalPagar;
        spanVuelto.textContent = formatearPrecio(vuelto);
        divVuelto.style.display = vuelto >= 0 ? 'block' : 'none';
    } else {
        divVuelto.style.display = 'none';
    }
}

function confirmarPago() {
    const metodoPago = document.querySelector('input[name="metodoPago"]:checked').value;
    const totalPagar = parseFloat(document.getElementById('modal-pago-total').textContent.replace('$', '').replace(/\./g, '').replace(',', '.')) || 0;
    const numeroOrden = document.getElementById('modal-pago-numero-orden').textContent;

    // Validacion para efectivo
    if (metodoPago === 'Efectivo') {
        const montoRecibido = parseFloat(document.getElementById('txtMontoRecibido').value) || 0;

        if (montoRecibido <= 0) {
            alert('Por favor ingrese el monto recibido');
            return;
        }

        if (montoRecibido < totalPagar) {
            alert('El monto recibido es menor al total a pagar');
            return;
        }

        // Guardar monto recibido en hidden field
        document.getElementById(window.hdnMontoRecibidoId).value = montoRecibido;
    } else {
        // Para tarjeta y transferencia, el monto recibido es igual al total
        document.getElementById(window.hdnMontoRecibidoId).value = totalPagar;
    }

    // Guardar metodo de pago en hidden field
    document.getElementById(window.hdnMetodoPagoId).value = metodoPago;

    // Guardar datos para modal de exito
    sessionStorage.setItem('pagoExitoso', JSON.stringify({
        orden: numeroOrden,
        metodo: metodoPago,
        total: document.getElementById('modal-pago-total').textContent
    }));

    // Cerrar modal de pago
    bootstrap.Modal.getInstance(document.getElementById('modalRealizarPago'))?.hide();

    // Ejecutar postback
    window.postbackConfirmarPago();
}

function cerrarModalExito() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('modalPagoExitoso'));
    if (modal) {
        modal.hide();
    }
    sessionStorage.removeItem('pagoExitoso');
}

// ===== INICIALIZACIÓN =====
function inicializarMesas() {
    mantenerFocoEnBusqueda();

    // Event listeners de modales
    document.getElementById('modalOrden')?.addEventListener('hidden.bs.modal', limpiarBusquedaAlCerrarModal);

    // Inicializar drag & drop para mesas
    initDragDrop();

    // Reinicializar drag & drop al cambiar de pestaña
    const tabButtons = document.querySelectorAll('#mesasTabs button[data-bs-toggle="tab"]');
    tabButtons.forEach(btn => {
        btn.addEventListener('shown.bs.tab', () => {
            setTimeout(initDragDrop, 100);
        });
    });

    // Event listener para modal de realizar pago
    const modalRealizarPago = document.getElementById('modalRealizarPago');
    if (modalRealizarPago) {
        modalRealizarPago.addEventListener('show.bs.modal', () => {
            // Copiar datos del modal de resumen al modal de pago
            document.getElementById('modal-pago-numero-orden').textContent =
                document.getElementById('modal-numero-orden').textContent;
            document.getElementById('modal-pago-fecha').textContent =
                document.getElementById('modal-fecha-orden').textContent;
            document.getElementById('modal-pago-mesa').textContent =
                document.getElementById('modal-ubicacion-mesa').textContent;

            // Obtener el nombre del mesero del span en el modal de resumen
            const spanMesero = document.getElementById('spanNombreMeseroResumen');
            const nombreMesero = spanMesero ? spanMesero.textContent.trim() : 'N/A';

            // Verificar si es mostrador (si el nombre es "Mostrador")
            const esMostrador = nombreMesero === 'Mostrador';
            const divMeseroPago = document.getElementById('divMeseroPago');

            if (esMostrador) {
                // Ocultar el campo de mesero si es mostrador
                divMeseroPago.style.display = 'none';
            } else {
                // Mostrar y llenar el campo de mesero
                divMeseroPago.style.display = 'block';
                document.getElementById('modal-pago-mesero').textContent = nombreMesero;
            }

            document.getElementById('modal-pago-total').textContent =
                document.getElementById('totalPagar').textContent;

            // Copiar productos
            const productosHTML = document.getElementById('resumenCompleto').innerHTML;
            document.getElementById('modal-pago-productos').innerHTML = productosHTML;

            // Resetear formulario
            document.getElementById('radioEfectivo').checked = true;
            document.getElementById('txtMontoRecibido').value = '';
            toggleMontoRecibido();
        });
    }

    // Verificar si hay pago exitoso en sessionStorage
    const pagoExitoso = sessionStorage.getItem('pagoExitoso');
    if (pagoExitoso) {
        const datos = JSON.parse(pagoExitoso);
        document.getElementById('modal-exito-orden').textContent = '#' + datos.orden;
        document.getElementById('modal-exito-metodo').textContent = datos.metodo;
        document.getElementById('modal-exito-total').textContent = datos.total;

        // Mostrar modal de exito
        setTimeout(() => {
            const modal = new bootstrap.Modal(document.getElementById('modalPagoExitoso'));
            modal.show();
        }, 500);
    }
}

// Inicializar al cargar el DOM
document.addEventListener('DOMContentLoaded', inicializarMesas);

// Reinicializar después de postbacks de ASP.NET
if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(() => {
        setTimeout(initDragDrop, 100);
    });
}
