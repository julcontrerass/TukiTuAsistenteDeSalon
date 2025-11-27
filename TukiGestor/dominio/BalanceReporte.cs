using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class BalanceReporte
    {
        public decimal TotalVentas { get; set; }
        public int CantidadVentas { get; set; }
        public int CantidadClientes { get; set; }
        public decimal TicketPromedio { get; set; }
        public decimal VentasEfectivo { get; set; }
        public decimal VentasCredito { get; set; }
        public decimal VentasDebito { get; set; }
        public decimal VentasTransferencia { get; set; }
        public int ProductosVendidos { get; set; }
        public decimal IngresosPorTurno { get; set; }
        public string TurnoMayorIngreso { get; set; }
    }

    public class VentaPorFormaPago
    {
        public string FormaPago { get; set; }
        public decimal Monto { get; set; }
        public int Cantidad { get; set; }
        public decimal Porcentaje { get; set; }
    }
}
