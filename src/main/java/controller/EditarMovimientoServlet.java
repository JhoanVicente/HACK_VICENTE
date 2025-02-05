package controller;

import model.Kardex;
import service.KardexService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "EditarMovimientoServlet", urlPatterns = {"/editarMovimiento"})
public class EditarMovimientoServlet extends HttpServlet {

    private final KardexService kardexService;

    public EditarMovimientoServlet() {
        this.kardexService = new KardexService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String movimientoIdStr = request.getParameter("movimientoId");
        if (movimientoIdStr != null && !movimientoIdStr.isEmpty()) {
            try {
                int movimientoId = Integer.parseInt(movimientoIdStr);
                Kardex movimiento = KardexController.obtenerCompraPorId(movimientoId); // Asegúrate de que este método funcione correctamente

                if (movimiento != null) {
                    request.setAttribute("movimiento", movimiento); // Pasa el objeto al JSP
                } else {
                    request.setAttribute("error", "No se encontró el movimiento con el ID especificado.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "El ID de movimiento no es válido.");
            }
        } else {
            request.setAttribute("error", "El parámetro movimientoId está vacío.");
        }
        request.getRequestDispatcher("/editarCompra.jsp").forward(request, response);
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener datos del formulario
            int movimientoId = Integer.parseInt(request.getParameter("kardexID"));
            java.sql.Date fecha = java.sql.Date.valueOf(request.getParameter("fecha")); // Convertir a Date
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));

            // Obtener el movimiento original
            Kardex movimiento = KardexController.obtenerCompraPorId(movimientoId);

            if (movimiento == null) {
                request.setAttribute("error", "No se encontró el movimiento.");
                request.getRequestDispatcher("/editarMovimiento.jsp").forward(request, response);
                return;
            }

            // Calcular el monto total nuevamente
            double precioUnitario = movimiento.getPrecioUnitario();
            double montoTotal = cantidad * precioUnitario;

            // Actualizar el objeto Kardex con los nuevos valores
            movimiento.setFecha(fecha);
            movimiento.setCantidad(cantidad);
            movimiento.setMontoTotal(montoTotal);

            // Actualizar en la base de datos
            boolean actualizado = kardexService.actualizarMovimiento(movimiento);

            if (actualizado) {
                response.sendRedirect("listarCompras.jsp"); // Redirige a la lista después de editar
            } else {
                request.setAttribute("error", "No se pudo actualizar el movimiento.");
                request.setAttribute("movimiento", movimiento);
                request.getRequestDispatcher("/editarMovimiento.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar los datos del formulario.");
            request.getRequestDispatcher("/editarMovimiento.jsp").forward(request, response);
        }
    }

}
