package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.Normalizer;
import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class AdminController {

    @Autowired
    private UsuarioRepository usuarioRepository;
    private final Map<Integer, String> mapaRoles = Map.of(
            1, "Superadmin",
            2, "Administrador",
            3, "Coordinador",
            4, "Vecino"
    );
    @Autowired
    private TarifaRepository tarifaRepository;

    @Autowired
    private ServicioRepository servicioRepository;

    @Autowired
    private SedeServicioRepository sedeServicioRepository;
    @Autowired
    private EstadoRepository estadoRepository;
    @Autowired
    private ReservaRepository reservaRepository;
    @Autowired
    private PagoRepository pagoRepository;
    @Autowired
    private SedeRepository sedeRepository;
    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;
    @Autowired
    private HorarioAtencionRepository horarioAtencionRepository;

    private void cargarEstadisticas(Model model, YearMonth mes, String rol) {
        if (mes == null) {
            mes = YearMonth.now();
        }

        LocalDate inicioMes = mes.atDay(1);
        LocalDate finMes = mes.atEndOfMonth();
        LocalDateTime inicioLdt = inicioMes.atStartOfDay();
        LocalDateTime finLdt = finMes.atTime(LocalTime.MAX);
        Timestamp inicioTs = Timestamp.valueOf(inicioLdt);
        Timestamp finTs = Timestamp.valueOf(finLdt);

        long reservasDelMes = reservaRepository.countByFechaCreacionBetween(inicioLdt, finLdt);
        long usuariosTotales = (rol == null || rol.isEmpty())
                ? usuarioRepository.count()
                : usuarioRepository.countUsuariosPorNombreRol(rol);
        long usuariosNuevos = usuarioRepository.countByCreateTimeBetween(inicioTs, finTs);

        model.addAttribute("reservasDelMes", reservasDelMes);
        model.addAttribute("usuariosTotales", usuariosTotales);
        model.addAttribute("usuariosNuevos", usuariosNuevos);
        model.addAttribute("mesActual", mes.toString());
        model.addAttribute("rolActual", rol);
    }




    // Vista principal del superadmin
    @GetMapping("/admin")
    public String adminHome(Model model) {
        System.out.println("Entrando a controlador /admin");

        model.addAttribute("rol", "admin");
        model.addAttribute("usuariosConectados", 0); // Temporal o lo puedes quitar
        model.addAttribute("totalReservas", reservaRepository.count());
        model.addAttribute("totalSedes", sedeRepository.count());

        // Agregamos las métricas del mes actual y sin filtro de rol
        YearMonth mesActual = YearMonth.now();
        cargarEstadisticas(model, mesActual, null);

        try {
            ObjectMapper objectMapper = new ObjectMapper();

            // Reservas por día (para gráfico de línea)
            List<Map<String, Object>> reservasPorDia = reservaRepository.countReservasPorDiaFormatted();
            model.addAttribute("reservasPorDiaJson", objectMapper.writeValueAsString(reservasPorDia));

            // Usuarios por rol (para gráfico de torta)
            List<Map<String, Object>> usuariosPorRol = usuarioRepository.countUsuariosPorRolFormatted();
            model.addAttribute("usuariosPorRolJson", objectMapper.writeValueAsString(usuariosPorRol));

            // Reservas por estado (opcional)
            List<Map<String, Object>> estadoReservas = reservaRepository.countReservasPorEstado()
                    .stream()
                    .map(row -> {
                        Map<String, Object> map = new HashMap<>();
                        map.put("estado", row[0]);
                        map.put("cantidad", row[1]);
                        return map;
                    }).collect(Collectors.toList());
            model.addAttribute("estadoReservasJson", objectMapper.writeValueAsString(estadoReservas));

        } catch (JsonProcessingException e) {
            e.printStackTrace(); // También puedes redirigir a una página de error o loguear mejor
        }

        return "admin/home";
    }


    // Vista de gestión de usuarios

    // En SuperAdminController.java

    @GetMapping("/perfil-admin")
    public String verPerfilAdmin(HttpSession session, Model model) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";
        model.addAttribute("perfil", usuario);
        return "admin/perfil";
    }

    @PostMapping("/perfil-admin/actualizar")
    public String actualizarPerfilAdmin(HttpSession session,
                                             @RequestParam String correo,
                                             @RequestParam String telefono,
                                             @RequestParam String direccion) {
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) return "redirect:/login";

        Usuario u = usuarioRepository.findByIdusuario(usuario.getIdusuario());
        if (u != null) {
            u.setEmail(correo);
            u.setTelefono(telefono);
            u.setDireccion(direccion);
            usuarioRepository.save(u);
            session.setAttribute("usuario", u); // actualizar en sesión
        }
        return "redirect:/perfil-admin?success";
    }
    @GetMapping("/admin/usuarios/registrados")
    public String listarUsuarios(
            @RequestParam(required = false) String filtro,
            @RequestParam(required = false, defaultValue = "nombre") String campo,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("idusuario").ascending());
        Page<Usuario> paginaUsuarios;

        if (filtro != null && !filtro.trim().isEmpty()) {
            String valor = filtro.trim().toLowerCase();
            paginaUsuarios = switch (campo) {
                case "correo" -> usuarioRepository.buscarPorCorreo(valor, pageable);
                case "estado" -> usuarioRepository.buscarPorEstado(valor, pageable);
                case "rol" -> usuarioRepository.buscarPorRol(valor, pageable);
                case "id" -> usuarioRepository.buscarPorId(valor, pageable);
                default -> usuarioRepository.buscarPorNombre(valor, pageable);
            };
        } else {
            paginaUsuarios = usuarioRepository.findAll(pageable);
        }

        model.addAttribute("usuarios", paginaUsuarios.getContent());
        model.addAttribute("pagina", paginaUsuarios);
        model.addAttribute("paginaActual", page);
        model.addAttribute("totalPaginas", paginaUsuarios.getTotalPages());
        model.addAttribute("filtro", filtro);
        model.addAttribute("campo", campo);
        model.addAttribute("mapaRoles", mapaRoles);
        return "admin/usuarios_registrados";
    }
    @PostMapping("/admin/cambiar-rol")
    public String cambiarRolAdmin(@RequestParam Integer idusuario,
                             @RequestParam Integer rol,
                             HttpSession session,
                             RedirectAttributes attr) {

        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);

        // Verificar que el usuario existe
        if (u == null) {
            attr.addFlashAttribute("mensajeError", "El usuario no existe.");
            return "redirect:/admin/usuarios/registrados";
        }

        //Verificar que no se trate de un superadmin o admin
        if (u.getIdrol() == 1 || u.getIdrol() == 2) {
            attr.addFlashAttribute("mensajeError", "No puedes cambiar el rol de un Superadmin ni de un Admin.");
            return "redirect:/admin/usuarios/registrados";
        }

        // Verificar que no se cambie a sí mismo ni a superadmin
        if (mapaRoles.containsKey(rol)
                && !usuarioLogueado.getIdusuario().equals(u.getIdusuario())
                && rol != 1 && rol !=2) {
            u.setIdrol(rol);
            usuarioRepository.save(u);
            attr.addFlashAttribute("mensajeExito", "Rol actualizado correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "No está permitido asignar el rol de Superadmin.");
        }

        return "redirect:/admin/usuarios/registrados";
    }


    @GetMapping("/admin/volver")
    public String volverAAdmin(HttpServletRequest request) {
        Usuario original = (Usuario) request.getSession().getAttribute("usuario_original");
        if (original != null) {
            request.getSession().setAttribute("usuario", original);
            request.getSession().removeAttribute("usuario_original");
        }
        return "redirect:/admin";
    }

    // Banear usuario (poner inactivo)
    @PostMapping("/admin/usuarios/registrados/{id}/ban")
    public String banearUsuario(@PathVariable("id") Integer idusuario, RedirectAttributes attr) {
        Usuario u = usuarioRepository.findById(idusuario).orElse(null);
        if (u != null && u.getIdrol() != 1 && u.getIdrol() != 2) {
            u.setEstado("inactivo");
            usuarioRepository.save(u);
            attr.addFlashAttribute("mensajeExito", "Usuario inactivado correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "No puedes banear a un Admin o Superadmin.");
        }
        return "redirect:/admin/usuarios/registrados";
    }


    // Activar usuario
    @PostMapping("/admin/usuarios/registrados/{id}/activar")
    public String activarUsuario(@PathVariable("id") Integer idusuario, RedirectAttributes attr) {
        Usuario usuario = usuarioRepository.findById(idusuario).orElse(null);
        if (usuario != null && usuario.getIdrol() != 1 && usuario.getIdrol() != 2) {
            usuario.setEstado("activo");
            usuarioRepository.save(usuario);
            attr.addFlashAttribute("mensajeExito", "Usuario activado correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "No puedes activar a un Admin o Superadmin.");
        }
        return "redirect:/admin/usuarios/registrados";
    }
    @PostMapping("/admin/usuarios/registrados/guardar")
    public String guardarUsuario(@ModelAttribute Usuario usuario,
                                 @RequestParam("rawPassword") String rawPassword,
                                 RedirectAttributes attr) {

        // Validar que el rol no sea Superadmin
        if (usuario.getIdrol() != null && usuario.getIdrol() == 1) {
            attr.addFlashAttribute("mensajeError", "No está permitido crear usuarios con rol Superadmin.");
            return "redirect:/admin/usuarios/registrados/nuevo";
        }

        usuario.setEstado("activo");
        usuario.setCreateTime(new Timestamp(System.currentTimeMillis()));

        // Hashear contraseña
        String passwordHash = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
        usuario.setPasswordHash(passwordHash);

        usuarioRepository.save(usuario);
        attr.addFlashAttribute("mensajeExito", "Usuario registrado exitosamente.");
        return "redirect:/admin/usuarios/registrados";
    }

    // Crear usuario
    @GetMapping("/admin/usuarios/registrados/nuevo")
    public String mostrarFormularioNuevoUsuario(Model model) {
        model.addAttribute("usuario", new Usuario()); // objeto vacío para el form
        return "admin/nuevo_usuario";
    }


    // Manejo de errores global para debugging
    @ExceptionHandler(Exception.class)
        public String handleException(Exception e) {
            e.printStackTrace(); // Log para consola
            return "error";       // Asegúrate de tener un error.html
        }
    @PostMapping("/admin/usuarios/registrados/actualizar")
    public String actualizarUsuario(@ModelAttribute("usuario") Usuario usuarioForm,
                                    @RequestParam(value = "rawPassword", required = false) String rawPassword) {
        Usuario existente = usuarioRepository.findById(usuarioForm.getIdusuario()).orElse(null);
        if (existente == null) return "redirect:/admin/usuarios/registrados";

        existente.setNombres(usuarioForm.getNombres());
        existente.setApellidos(usuarioForm.getApellidos());
        existente.setEmail(usuarioForm.getEmail());
        existente.setTelefono(usuarioForm.getTelefono());
        existente.setDireccion(usuarioForm.getDireccion());
        existente.setIdrol(usuarioForm.getIdrol());
        existente.setNotificarRecordatorio(usuarioForm.getNotificarRecordatorio());
        existente.setNotificarDisponibilidad(usuarioForm.getNotificarDisponibilidad());


        if (rawPassword != null && !rawPassword.trim().isEmpty()) {
            existente.setPasswordHash(new BCryptPasswordEncoder().encode(rawPassword));
        }

        usuarioRepository.save(existente);
        return "redirect:/admin/usuarios/registrados";
    }
    @GetMapping("/admin/usuarios/registrados/editar/{id}")
    public String mostrarFormularioEdicionUsuario(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Usuario> optionalUsuario = usuarioRepository.findById(id);
        if (optionalUsuario.isPresent()) {
            Usuario usuario = optionalUsuario.get();
            if (usuario.getIdrol() == 1 || usuario.getIdrol() == 2) {
                attr.addFlashAttribute("mensajeError", "No puedes editar a un Admin o Superadmin.");
                return "redirect:/admin/usuarios/registrados";
            }
            model.addAttribute("usuario", usuario);
            return "admin/admin_usuarios_formulario";
        } else {
            attr.addFlashAttribute("mensajeError", "Usuario no encontrado.");
            return "redirect:/admin/usuarios/registrados";
        }
    }
    @PostMapping("/admin/usuarios/registrados/eliminar")
    public String eliminarUsuario(@RequestParam("idusuario") Integer idusuario, HttpSession session, RedirectAttributes attr) {
        Integer sessionId = (Integer) session.getAttribute("idusuario");

        if (idusuario.equals(sessionId)) {
            attr.addFlashAttribute("mensajeError", "No puedes eliminarte a ti mismo.");
            return "redirect:/admin/usuarios/registrados";
        }

        Usuario u = usuarioRepository.findById(idusuario).orElse(null);

        if (u == null) {
            attr.addFlashAttribute("mensajeError", "Usuario no encontrado.");
        } else if (u.getIdrol() == 1 || u.getIdrol() == 2) {
            attr.addFlashAttribute("mensajeError", "No puedes eliminar a un Admin o Superadmin.");
        } else {
            usuarioRepository.deleteById(idusuario);
            attr.addFlashAttribute("mensajeExito", "Usuario eliminado correctamente.");
        }

        return "redirect:/admin/usuarios/registrados";
    }
    @GetMapping("/admin/servicios/disponibles")
    public String listarSedes(Model model) {
        List<Sede> sedes = sedeRepository.findAll();
        model.addAttribute("listaSedes", sedes);
        return "admin/servicios-disponibles";
    }
    @PostMapping("/admin/servicios/disponibles/desactivar/{id}")
    public String desactivarSede(@PathVariable("id") int id) {
        Optional<Sede> optSede = sedeRepository.findById(id);
        if (optSede.isPresent()) {
            Sede sede = optSede.get();
            sede.setActivo(false);
            sedeRepository.save(sede);
        }
        return "redirect:/admin/servicios/disponibles";
    }
    @PostMapping("/admin/servicios/disponibles/activar/{id}")
    public String activarSede(@PathVariable("id") int id) {
        Optional<Sede> optSede = sedeRepository.findById(id);
        if (optSede.isPresent()) {
            Sede sede = optSede.get();
            sede.setActivo(true);
            sedeRepository.save(sede);
        }
        return "redirect:/admin/servicios/disponibles";
    }
    @GetMapping("/admin/servicios/disponibles/ver/{id}")
    public String verSede(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isPresent()) {
            model.addAttribute("sede", optionalSede.get());
            return "admin/servicios_detalles";
        } else {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/admin/servicio/disponibles";
        }
    }
    public enum DiaSemana {
        LUNES, MARTES, MIERCOLES, JUEVES, VIERNES, SABADO, DOMINGO
    }

    public String normalizarDia(String input) {
        return Normalizer.normalize(input, Normalizer.Form.NFD)
                .replaceAll("[\\p{InCombiningDiacriticalMarks}]", "") // elimina tildes
                .toUpperCase(Locale.ROOT); // asegura mayúsculas en inglés
    }



    @GetMapping("/admin/servicios/disponibles/configurar/{id}")
    public String configurarSede(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {

        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isEmpty()) {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/admin/servicio/disponibles";
        }

        Sede sede = optionalSede.get();
        model.addAttribute("sede", sede);
        model.addAttribute("listaServicios", servicioRepository.findAll());
        model.addAttribute("listaTarifas", tarifaRepository.findAll());
        model.addAttribute("dias", List.of("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"));

        // Cargar o generar los 7 días
        List<HorarioAtencion> horarios = new ArrayList<>();
        for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
            Optional<HorarioAtencion> ha = horarioAtencionRepository.findBySedeAndDiaSemana(sede, dia);
            horarios.add(ha.orElse(new HorarioAtencion(null, sede, dia, null, null, false)));
        }
        model.addAttribute("listaHorariosAtencion", horarios);

        model.addAttribute("horariosDisponibles", horarioDisponibleRepository.findByHorarioAtencion_Sede_Idsede(id));

        return "admin/servicios_configurar";
    }



    @PostMapping("/admin/servicios/disponibles/configurar/service")
    public String asignarServicio(@RequestParam("idsede") Integer idsede,
                                  @RequestParam("idservicio") Integer idservicio,
                                  @RequestParam("idtarifa") Integer idtarifa,
                                  RedirectAttributes attr) {

        Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
        Optional<Servicio> servOpt = servicioRepository.findById(idservicio);
        Optional<Tarifa> tarifaOpt = tarifaRepository.findById(idtarifa);

        if (sedeOpt.isPresent() && servOpt.isPresent() && tarifaOpt.isPresent()) {
            SedeServicio ss = new SedeServicio();
            ss.setSede(sedeOpt.get());
            ss.setServicio(servOpt.get());
            ss.setTarifa(tarifaOpt.get());
            sedeServicioRepository.save(ss);

            attr.addFlashAttribute("mensajeExito", "Servicio asignado a la sede correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "Error al asignar servicio.");
        }

        return "redirect:/admin/servicios/disponibles/configurar/" + idsede;
    }


    @PostMapping("/admin/servicios/disponibles/configurar/atencion/guardar")
    public String guardarHorariosAtencion(@RequestParam("idsede") Integer idsede,
                                          HttpServletRequest request,
                                          RedirectAttributes attr) {
        Optional<Sede> sedeOpt = sedeRepository.findById(idsede);
        if (sedeOpt.isEmpty()) {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/admin/servicios/disponibles";
        }

        Sede sede = sedeOpt.get();

        for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
            String nombreDia = dia.name(); // Ej. "LUNES"

            String inicioParam = request.getParameter("horaInicio_" + nombreDia);
            String finParam = request.getParameter("horaFin_" + nombreDia);
            boolean activo = request.getParameter("activo_" + nombreDia) != null;

            LocalTime horaInicio = null;
            LocalTime horaFin = null;

            if (inicioParam != null && !inicioParam.isEmpty()) {
                horaInicio = LocalTime.parse(inicioParam);
            }
            if (finParam != null && !finParam.isEmpty()) {
                horaFin = LocalTime.parse(finParam);
            }

            // Buscar o crear el horario para ese día
            HorarioAtencion horario = horarioAtencionRepository.findBySedeAndDiaSemana(sede, dia)
                    .orElse(new HorarioAtencion(null, sede, dia, null, null, false));

            horario.setHoraInicio(horaInicio);
            horario.setHoraFin(horaFin);
            horario.setActivo(activo);

            horarioAtencionRepository.save(horario);
        }

        attr.addFlashAttribute("mensajeExito", "Horarios de atención actualizados.");
        return "redirect:/admin/servicios/disponibles/configurar/" + idsede;
    }



    @PostMapping("/admin/servicios/disponibles/configurar/intervalos")
    public String agregarHorarioDisponible(@RequestParam("idhorarioAtencion") Integer idHorarioAtencion,
                                           @RequestParam("idservicio") Integer idservicio,
                                           @RequestParam("horaInicio") String horaInicio,
                                           @RequestParam("horaFin") String horaFin,
                                           RedirectAttributes attr) {

        Optional<HorarioAtencion> haOpt = horarioAtencionRepository.findById(idHorarioAtencion);
        Optional<Servicio> servOpt = servicioRepository.findById(idservicio);

        if (haOpt.isPresent() && servOpt.isPresent()) {
            HorarioDisponible intervalo = new HorarioDisponible();
            intervalo.setHorarioAtencion(haOpt.get());
            intervalo.setServicio(servOpt.get());
            intervalo.setHoraInicio(LocalTime.parse(horaInicio));
            intervalo.setHoraFin(LocalTime.parse(horaFin));
            intervalo.setActivo(true);

            horarioDisponibleRepository.save(intervalo);
            attr.addFlashAttribute("mensajeExito", "Intervalo agregado correctamente.");
        } else {
            attr.addFlashAttribute("mensajeError", "No se encontró el horario o servicio asociado.");
        }

        return "redirect:/admin/servicios/disponibles/configurar/" + haOpt.map(h -> h.getSede().getIdsede()).orElse(-1);
    }






    @GetMapping("/admin/servicios/disponibles/editar/{id}")
    public String mostrarFormularioEdicion(@PathVariable("id") Integer id, Model model, RedirectAttributes attr) {
        Optional<Sede> optionalSede = sedeRepository.findById(id);
        if (optionalSede.isPresent()) {
            model.addAttribute("sede", optionalSede.get());
            return "admin/servicios_editar"; // ¡nombre corregido!
        } else {
            attr.addFlashAttribute("mensajeError", "Sede no encontrada.");
            return "redirect:/admin/servicios/disponibles";
        }
    }

    @PostMapping("/admin/servicios/disponibles/actualizar")
    public String actualizarSede(@ModelAttribute("sede") Sede sede, RedirectAttributes attr) {
        sedeRepository.save(sede);
        attr.addFlashAttribute("mensajeExito", "Sede actualizada correctamente.");
        return "redirect:/admin/servicios/disponibles";
    }



    @PostMapping("/admin/servicios/disponibles/guardar")
    public String guardarSede(@ModelAttribute("sede") Sede sede) {
        // Establece el distrito fijo
        sede.setDistrito("San Miguel");

        sedeRepository.save(sede);

        if (sede.getIdsede() != null && horarioAtencionRepository.countBySede(sede) == 0) {
            for (HorarioAtencion.DiaSemana dia : HorarioAtencion.DiaSemana.values()) {
                HorarioAtencion ha = new HorarioAtencion();
                ha.setSede(sede);
                ha.setDiaSemana(dia);
                if (dia == HorarioAtencion.DiaSemana.Domingo) {
                    ha.setHoraInicio(LocalTime.of(0, 0));
                    ha.setHoraFin(LocalTime.of(0, 0));
                    ha.setActivo(false);
                } else {
                    ha.setHoraInicio(LocalTime.of(8, 0));
                    ha.setHoraFin(LocalTime.of(20, 0));
                    ha.setActivo(true);
                }
                horarioAtencionRepository.save(ha);
            }
        }

        return "redirect:/admin/servicios/disponibles";
    }
    @GetMapping("/admin/tarifas")
    public String listarTarifas(Model model) {
        List<Tarifa> tarifas = tarifaRepository.findAll();
        model.addAttribute("listaTarifas", tarifas);
        return "admin/admin_tarifas";
    }
    @GetMapping("/admin/tarifas/nueva")
    public String nuevaTarifa(Model model) {
        model.addAttribute("tarifa", new Tarifa());
        return "admin/admin_tarifa_nueva";
    }

    // Guardar nueva tarifa
    @PostMapping("/admin/tarifas/guardar")
    public String guardarTarifa(@ModelAttribute Tarifa tarifa) {
        tarifa.setFechaActualizacion(LocalDate.now());
        tarifaRepository.save(tarifa);
        return "redirect:/admin/tarifas";
    }

    // Mostrar formulario para editar tarifa
    @GetMapping("/admin/tarifas/editar/{id}")
    public String editarTarifa(@PathVariable("id") Integer id, Model model) {
        Tarifa tarifa = tarifaRepository.findById(id).orElse(null);
        if (tarifa != null) {
            model.addAttribute("tarifa", tarifa);
            return "admin/admin_tarifa_editar";
        } else {
            return "redirect:/admin/tarifas";
        }
    }

    // Guardar cambios en tarifa existente
    @PostMapping("/admin/tarifas/actualizar")
    public String actualizarTarifa(@ModelAttribute Tarifa tarifa) {
        tarifa.setFechaActualizacion(LocalDate.now());
        tarifaRepository.save(tarifa);
        return "redirect:/admin/tarifas";
    }
    @GetMapping("/admin/tarifas/eliminar/{id}")
    public String eliminarTarifa(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        if (tarifaRepository.existsById(id)) {
            tarifaRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("mensajeExito", "Tarifa eliminada correctamente.");
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "La tarifa no existe.");
        }
        return "redirect:/admin/tarifas";
    }
    @GetMapping("/admin/pagos/historial")
    public String listarPagos(Model model) {
        List<Pago> listaPagos = pagoRepository.findAll();
        model.addAttribute("listaPagos", listaPagos);
        return "admin/pagos-historial";
    }
    @PostMapping("/admin/pagos/historial/aprobar/{id}")
    public String aprobarPagoDesdePagos(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/admin/pagos/historial";

        Estado estadoConfirmado = estadoRepository.findByNombreAndTipoAplicacion("confirmado", Estado.TipoAplicacion.pago);
        Estado estadoAprobadoReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
        if (estadoConfirmado == null || estadoAprobadoReserva == null) return "redirect:/admin/pagos/historial";

        pago.setEstado(estadoConfirmado);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoAprobadoReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/admin/pagos/historial";
    }

    @PostMapping("/admin/pagos/historial/rechazar/{id}")
    public String rechazarPago(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/admin/pagos/historial";

        Estado estadoRechazado = estadoRepository.findByNombreAndTipoAplicacion("rechazado", Estado.TipoAplicacion.pago);
        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        if (estadoRechazado == null || estadoPendienteReserva == null) return "redirect:/admin/pagos/historial";

        pago.setEstado(estadoRechazado);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoPendienteReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/admin/pagos/historial";
    }

    @PostMapping("/admin/pagos/historial/pendiente/{id}")
    public String volverPagoAPendiente(@PathVariable("id") Integer id) {
        Pago pago = pagoRepository.findById(id).orElse(null);
        if (pago == null) return "redirect:/admin/pagos/historial";

        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        if (estadoPendientePago == null || estadoPendienteReserva == null) return "redirect:/admin/pagos/historial";

        pago.setEstado(estadoPendientePago);
        pagoRepository.save(pago);

        Reserva reserva = reservaRepository.findByPago(pago);
        if (reserva != null) {
            reserva.setEstado(estadoPendienteReserva);
            reservaRepository.save(reserva);
        }

        return "redirect:/admin/pagos/historial";
    }
    @GetMapping("/admin/estadisticas")
    public String verEstadisticas(@RequestParam(value = "mes", required = false) @DateTimeFormat(pattern = "yyyy-MM") YearMonth mes,
                                  @RequestParam(value = "rol", required = false) String rol,
                                  Model model) {
        cargarEstadisticas(model, mes, rol);
        return "admin/admin_estadisticas";
    }
    @GetMapping("/admin/reservas")
    public String listarReservas(
            @RequestParam(required = false) String filtro,
            @RequestParam(required = false, defaultValue = "vecino") String campo,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("fechaReserva").descending());
        Page<Reserva> paginaReservas;

        if (filtro != null && !filtro.trim().isEmpty()) {
            String valor = filtro.trim().toLowerCase();
            paginaReservas = switch (campo) {
                case "estado" -> reservaRepository.filtrarPorEstado(valor, pageable);
                case "sede" -> reservaRepository.filtrarPorSede(valor, pageable);
                case "fecha" -> reservaRepository.filtrarPorFecha(LocalDate.parse(valor), pageable);
                default -> reservaRepository.filtrarPorVecino(valor, pageable);
            };
        } else {
            paginaReservas = reservaRepository.findAll(pageable);
        }

        model.addAttribute("reservas", paginaReservas.getContent());
        model.addAttribute("pagina", paginaReservas);
        model.addAttribute("paginaActual", page);
        model.addAttribute("totalPaginas", paginaReservas.getTotalPages());
        model.addAttribute("campo", campo);
        model.addAttribute("filtro", filtro);

        return "admin/admin_reservas";
    }
    @PostMapping("/admin/reservas/aprobar-pago/{id}")
    public String aprobarPago(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);

        if (reserva != null && reserva.getPago() != null) {
            Estado aprobadoReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
            Estado confirmadoPago = estadoRepository.findByNombreAndTipoAplicacion("confirmado", Estado.TipoAplicacion.pago);

            if (aprobadoReserva != null && confirmadoPago != null) {
                reserva.setEstado(aprobadoReserva);
                reservaRepository.save(reserva);

                Pago pago = reserva.getPago();
                pago.setEstado(confirmadoPago);
                pago.setFechaPago(LocalDateTime.now());
                pagoRepository.save(pago);

                redirectAttributes.addFlashAttribute("mensajeExito", "Pago aprobado exitosamente.");
            } else {
                redirectAttributes.addFlashAttribute("mensajeError", "Estados no encontrados.");
            }
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "Reserva sin pago asociado.");
        }

        return "redirect:/admin/reservas";
    }
    @PostMapping("/admin/reservas/desaprobar-pago/{id}")
    public String desaprobarPago(@PathVariable("id") Integer id) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        if (reserva != null && reserva.getPago() != null) {
            Estado pendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
            Estado pendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);

            reserva.setEstado(pendienteReserva);
            reservaRepository.save(reserva);

            Pago pago = reserva.getPago();
            pago.setEstado(pendientePago);
            pagoRepository.save(pago);
        }
        return "redirect:/admin/reservas";
    }
    @GetMapping("/admin/reservas/nueva")
    public String nuevaReserva(Model model) {
        model.addAttribute("reserva", new Reserva());

        List<Sede> sedes = sedeRepository.findAll();
        model.addAttribute("listaSedes", sedes);

        List<HorarioDisponible> listaHorarios = horarioDisponibleRepository.findByActivoTrue();
        model.addAttribute("listaHorarios", listaHorarios);

        return "admin/reserva_nueva";
    }
    @PostMapping("/admin/reservas/guardar")
    public String guardarReserva(@RequestParam("dni") String dni,
                                 @RequestParam("idsedeServicio") Integer idsedeServicio,
                                 @RequestParam("idhorario") Integer idhorario,
                                 @ModelAttribute("reserva") Reserva reserva,
                                 RedirectAttributes redirectAttributes) {



        Usuario usuario = usuarioRepository.findByDni(dni);
        if (usuario == null) {
            redirectAttributes.addFlashAttribute("mensajeError", "El DNI ingresado no corresponde a ningún usuario registrado.");
            return "redirect:/admin/reservas/nueva";
        }

        Estado estadoPendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
        Estado estadoPendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
        Estado estadoAprobadaReserva = estadoRepository.findByNombreAndTipoAplicacion("aprobada", Estado.TipoAplicacion.reserva);
        Estado estadoPagado = estadoRepository.findByNombreAndTipoAplicacion("pagado", Estado.TipoAplicacion.pago);

        SedeServicio sedeServicio = sedeServicioRepository.findById(idsedeServicio).orElse(null);

        if (sedeServicio == null) {
            redirectAttributes.addFlashAttribute("mensajeError", "No se encontró el servicio seleccionado.");
            return "redirect:/admin/reservas/nueva";
        }

        reserva.setSedeServicio(sedeServicio);

        HorarioDisponible horario = horarioDisponibleRepository.findById(idhorario).orElse(null);
        if (horario == null || !horario.getActivo()) {
            redirectAttributes.addFlashAttribute("mensajeError", "El horario seleccionado no es válido o está inactivo.");
            return "redirect:/admin/reservas/nueva";
        }
        reserva.setHorarioDisponible(horario);

        // Validar que el horario esté definido y activo


        // Validar que el horario corresponda al servicio seleccionado
        if (!horario.getServicio().equals(sedeServicio.getServicio())) {
            redirectAttributes.addFlashAttribute("mensajeError", "El horario seleccionado no pertenece al servicio escogido.");
            return "redirect:/admin/reservas/nueva";
        }

        // Validar que el día de la reserva coincida con el día del horario
        DayOfWeek dayOfWeek = reserva.getFechaReserva().getDayOfWeek();
        HorarioAtencion.DiaSemana diaReserva = switch (dayOfWeek) {
            case MONDAY    -> HorarioAtencion.DiaSemana.Lunes;
            case TUESDAY   -> HorarioAtencion.DiaSemana.Martes;
            case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
            case THURSDAY  -> HorarioAtencion.DiaSemana.Jueves;
            case FRIDAY    -> HorarioAtencion.DiaSemana.Viernes;
            case SATURDAY  -> HorarioAtencion.DiaSemana.Sábado;
            case SUNDAY    -> HorarioAtencion.DiaSemana.Domingo;
        };
        HorarioAtencion.DiaSemana diaHorario = horario.getHorarioAtencion().getDiaSemana();

        if (!diaReserva.equals(diaHorario)) {
            redirectAttributes.addFlashAttribute("mensajeError", "El horario no corresponde al día seleccionado.");
            return "redirect:/admin/reservas/nueva";
        }

        // Validar que la fecha no sea pasada
        if (reserva.getFechaReserva() == null || reserva.getFechaReserva().isBefore(LocalDate.now())) {
            redirectAttributes.addFlashAttribute("mensajeError", "La fecha de reserva no puede ser pasada.");
            return "redirect:/admin/reservas/nueva";
        }

        // Validar si ese día está permitido para esa sede
        Sede sede = sedeServicio.getSede();
        boolean diaPermitido = horarioAtencionRepository.existsBySedeAndDiaSemanaAndActivoTrue(sede, diaReserva);
        if (!diaPermitido) {
            redirectAttributes.addFlashAttribute("mensajeError", "No se permiten reservas el día seleccionado.");
            return "redirect:/admin/reservas/nueva";
        }

        // (Opcional) Validar si ya existe una reserva para ese horario y fecha
        boolean yaReservado = reservaRepository.existsByHorarioDisponibleAndFechaReserva(horario, reserva.getFechaReserva());
        if (yaReservado) {
            redirectAttributes.addFlashAttribute("mensajeError", "Ya existe una reserva para ese horario en la fecha indicada.");
            return "redirect:/admin/reservas/nueva";
        }

        // Crear y guardar pago + reserva
        if (usuario != null && sedeServicio != null && estadoPendienteReserva != null && estadoPendientePago != null) {
            Pago pago = new Pago();
            pago.setUsuario(usuario);
            pago.setMetodo(Pago.Metodo.banco); // puedes ajustar según lógica futura
            pago.setMonto(BigDecimal.valueOf(sedeServicio.getTarifa().getMonto()));
            pago.setEstado(estadoPendientePago);
            pago.setFechaPago(null);
            pagoRepository.save(pago);

            reserva.setUsuario(usuario);
            reserva.setFechaCreacion(LocalDateTime.now());
            reserva.setFechaLimitePago(reserva.getFechaCreacion().plusHours(4));
            reserva.setPago(pago);
            reserva.setEstado(pago.getEstado().equals(estadoPagado) ? estadoAprobadaReserva : estadoPendienteReserva);

            reservaRepository.save(reserva);
            redirectAttributes.addFlashAttribute("mensajeExito", "Reserva y pago creados correctamente.");
        } else {
            redirectAttributes.addFlashAttribute("mensajeError", "Error al crear la reserva. Verifique los datos.");
        }

        return "redirect:/admin/reservas";
    }
    @GetMapping("/admin/reservas/ver/{id}")
    public String verReserva(@PathVariable("id") Integer id, Model model) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        model.addAttribute("reserva", reserva);
        return "admin/reserva_detalle";
    }
    @PostMapping("/admin/reservas/cancelar/{id}")
    public String cancelarReserva(@PathVariable("id") Integer id) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        if (reserva != null) {
            Estado cancelada = estadoRepository.findByNombreAndTipoAplicacion("cancelada", Estado.TipoAplicacion.reserva);
            reserva.setEstado(cancelada);
            reservaRepository.save(reserva);
        }
        return "redirect:/admin/reservas";
    }
    @PostMapping("/admin/reservas/habilitar/{id}")
    public String habilitarReserva(@PathVariable("id") Integer id) {
        Reserva reserva = reservaRepository.findById(id).orElse(null);
        if (reserva != null) {
            Estado pendienteReserva = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.reserva);
            reserva.setEstado(pendienteReserva);
            reservaRepository.save(reserva);

            if (reserva.getPago() != null) {
                Estado pendientePago = estadoRepository.findByNombreAndTipoAplicacion("pendiente", Estado.TipoAplicacion.pago);
                reserva.getPago().setEstado(pendientePago);
                pagoRepository.save(reserva.getPago());
            }
        }
        return "redirect:/admin/reservas";
    }
    @GetMapping("/admin/promociones")
    public String listarPromociones(Model model) {
        List<Tarifa> tarifas = tarifaRepository.findAll();
        model.addAttribute("listaTarifas", tarifas);
        return "admin/admin_promociones";
    }
    @GetMapping("/admin/puntos-usuario")
    public String listarPuntos(Model model) {
        List<Tarifa> tarifas = tarifaRepository.findAll();
        model.addAttribute("listaTarifas", tarifas);
        return "admin/admin_puntos_usuarios";
    }
}
