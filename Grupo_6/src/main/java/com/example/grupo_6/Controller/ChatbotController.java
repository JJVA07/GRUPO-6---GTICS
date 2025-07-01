package com.example.grupo_6.Controller;

import com.example.grupo_6.Entity.*;
import com.example.grupo_6.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/chatbot")
@CrossOrigin(origins = "*")
public class ChatbotController {

    @Autowired
    private SedeRepository sedeRepository;

    @Autowired
    private SedeServicioRepository sedeServicioRepository;

    @Autowired
    private EstadoRepository estadoRepository;

    @Autowired
    private ServicioRepository servicioRepository;

    @Autowired
    private HorarioDisponibleRepository horarioDisponibleRepository;

    @Autowired
    private ReservaRepository reservaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping("/procesar")
    public ResponseEntity<Map<String, Object>> procesarMensaje(
            @RequestBody Map<String, Object> payload,
            HttpSession session) {

        System.out.println("📥 Payload recibido desde Dialogflow:");
        System.out.println(payload);

        Map<String, Object> queryResult = (Map<String, Object>) payload.get("queryResult");
        String intent = (String) ((Map<String, Object>) queryResult.get("intent")).get("displayName");
        Map<String, Object> parametros = (Map<String, Object>) queryResult.get("parameters");

        System.out.println("🔎 Intent detectado: " + intent);

        // 🧠 Obtener el ID del usuario desde user-id
        Integer idUsuarioChatbot = null;
        try {
            Map<String, Object> originalDetectIntentRequest = (Map<String, Object>) payload.get("originalDetectIntentRequest");
            if (originalDetectIntentRequest != null) {
                Map<String, Object> dfPayload = (Map<String, Object>) originalDetectIntentRequest.get("payload");
                if (dfPayload != null && dfPayload.get("userId") != null) {
                    idUsuarioChatbot = Integer.parseInt(dfPayload.get("userId").toString());
                    System.out.println("🧾 ID usuario desde user-id: " + idUsuarioChatbot);
                }
            }
        } catch (Exception e) {
            System.out.println("⚠️ No se pudo extraer el ID del usuario desde el payload: " + e.getMessage());
        }

        // 🔄 Obtener usuario desde sesión o por ID
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null && idUsuarioChatbot != null) {
            usuario = usuarioRepository.findById(idUsuarioChatbot).orElse(null);
        }

        // 🔤 Extraer nombre del usuario
        String nombreUsuario = (usuario != null && usuario.getNombres() != null)
                ? usuario.getNombres().split(" ")[0]
                : "usuario";

        // ----- INTENT: Saludo -----
        if ("Saludo".equals(intent)) {
            return ResponseEntity.ok(Map.of(
                    "fulfillmentText", "¡Hola " + nombreUsuario + "! ¿En qué puedo ayudarte hoy?"
            ));
        }
        if ("OpcionesBot".equals(intent)) {
            Map<String, Object> mensaje1 = Map.of(
                    "text", Map.of("text", List.of("🤖 ¡Hola! Aquí tienes lo que puedo hacer por ti:"))
            );

            Map<String, Object> mensaje2 = Map.of(
                    "text", Map.of("text", List.of(
                            "1️⃣ Ver los servicios deportivos disponibles\n" +
                                    "2️⃣ Consultar tus reservas (hoy, mañana o todas)\n" +
                                    "3️⃣ Ver canchas disponibles por sede y fecha"))
            );

            Map<String, Object> mensaje3 = Map.of(
                    "text", Map.of("text", List.of(
                            "💬 Ejemplos que puedes decirme:\n" +
                                    "• ¿Qué servicios hay?\n" +
                                    "• ¿Cuáles son mis reservas?\n" +
                                    "• ¿Qué canchas hay libres mañana en Magdalena?"))
            );

            return ResponseEntity.ok(Map.of("fulfillmentMessages", List.of(mensaje1, mensaje2, mensaje3)));
        }





        // ----- INTENT: ConsultarServiciosDisponibles -----
        if ("ConsultarServiciosDisponibles".equals(intent)) {
            List<Servicio> servicios = servicioRepository.listarServiciosActivos();

            if (servicios.isEmpty()) {
                return ResponseEntity.ok(Map.of("fulfillmentText", "No se encontraron servicios disponibles en este momento."));
            }

            StringBuilder respuestaServicios = new StringBuilder("📋 *Estos son los servicios deportivos disponibles:*\n\n");
            for (Servicio s : servicios) {
                respuestaServicios.append("• ").append(s.getNombre()).append("\n");
            }

            return ResponseEntity.ok(Map.of("fulfillmentText", respuestaServicios.toString()));
        }


        // ----- INTENT: ConsultarReservasUsuario -----
        if ("ConsultarReservasUsuario".equals(intent)) {
            if (usuario == null) {
                return ResponseEntity.ok(Map.of("fulfillmentText", "Primero debes iniciar sesión para consultar tus reservas."));
            }

            List<Reserva> reservasUsuario = reservaRepository.findByUsuarioIdusuario(usuario.getIdusuario());

            if (reservasUsuario.isEmpty()) {
                return ResponseEntity.ok(Map.of(
                        "fulfillmentText", "No tienes reservas registradas por el momento."
                ));
            }

            StringBuilder respuestaReservas = new StringBuilder("🗓 Estas son tus reservas:\n");
            for (Reserva r : reservasUsuario) {
                String nombreServicio = r.getSedeServicio().getServicio().getNombre();
                String fecha = r.getFechaReserva().toString();
                String hora = r.getHorarioDisponible().getHoraInicio().toString();
                respuestaReservas.append("• ").append(nombreServicio)
                        .append(" el ").append(fecha)
                        .append(" a las ").append(hora).append("\n");
            }

            return ResponseEntity.ok(Map.of("fulfillmentText", respuestaReservas.toString()));
        }

        // Parámetros comunes
        String sede = "";
        if (parametros.get("sede") instanceof Map sedeMap) {
            sede = sedeMap.getOrDefault("business-name", "").toString();
        } else if (parametros.get("sede") instanceof String) {
            sede = parametros.get("sede").toString();
        }
        else if (parametros.containsKey("location")) {
            Map<String, Object> locationMap = (Map<String, Object>) parametros.get("location");
            if (locationMap != null) {
                sede = (String) locationMap.getOrDefault("city", "");
            }
        }

        String fechaStr = "";
        if (parametros.containsKey("fecha")) {
            fechaStr = (String) parametros.get("fecha");
        } else if (parametros.containsKey("date")) {
            fechaStr = (String) parametros.get("date");
        }

        System.out.println("📦 Parámetros recibidos:");
        System.out.println("→ Sede: " + parametros.get("sede"));
        System.out.println("→ Fecha: " + parametros.get("fecha"));
        System.out.println("→ Hora: " + parametros.get("hora"));
        System.out.println("→ Servicio: " + parametros.get("servicio"));

        String respuesta;

        // ----- INTENT: ConsultarCanchasLibres -----
        if ("ConsultarCanchasLibres".equals(intent)) {
            if (fechaStr.isBlank() || sede.isBlank()) {
                respuesta = "Por favor indica una sede y una fecha válidas para consultar disponibilidad.";
            } else {
                try {
                    LocalDate fecha = LocalDate.parse(fechaStr);
                    DayOfWeek dow = fecha.getDayOfWeek();
                    HorarioAtencion.DiaSemana diaSemana = switch (dow) {
                        case MONDAY -> HorarioAtencion.DiaSemana.Lunes;
                        case TUESDAY -> HorarioAtencion.DiaSemana.Martes;
                        case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
                        case THURSDAY -> HorarioAtencion.DiaSemana.Jueves;
                        case FRIDAY -> HorarioAtencion.DiaSemana.Viernes;
                        case SATURDAY -> HorarioAtencion.DiaSemana.Sábado;
                        case SUNDAY -> HorarioAtencion.DiaSemana.Domingo;
                    };

                    List<HorarioDisponible> disponibles = horarioDisponibleRepository
                            .listarHorariosDisponiblesPorSedeYDiaSemana(sede, diaSemana);

                    if (disponibles.isEmpty()) {
                        respuesta = "Lo siento " + nombreUsuario + ", no se encontraron canchas disponibles en la sede " + sede + " para el " + fecha + ".";
                    } else {
                        StringBuilder sb = new StringBuilder();
                        sb.append("¡Perfecto, ").append(nombreUsuario).append("! Estas son las canchas disponibles en la sede ")
                                .append(sede).append(" para el ").append(fecha).append(":\n");
                        for (HorarioDisponible h : disponibles) {
                            sb.append("- ")
                                    .append(h.getServicio().getNombre())
                                    .append(" de ")
                                    .append(h.getHoraInicio())
                                    .append(" a ")
                                    .append(h.getHoraFin())
                                    .append("\n");
                        }
                        respuesta = sb.toString();
                    }

                } catch (Exception e) {
                    respuesta = "La fecha ingresada no tiene el formato correcto (yyyy-MM-dd).";
                    System.out.println("❌ Error al parsear la fecha: " + e.getMessage());
                }
            }

            return ResponseEntity.ok(Map.of("fulfillmentText", respuesta));
        }

// ----- INTENT: CrearReserva -----
        if ("CrearReserva".equals(intent)) {
            if (usuario == null) {
                return ResponseEntity.ok(Map.of("fulfillmentText", "Debes iniciar sesión antes de crear una reserva."));
            }

            String horaStr = parametros.get("hora") != null ? parametros.get("hora").toString() : "";
            if (sede.isBlank() || fechaStr.isBlank() || horaStr.isBlank()) {
                return ResponseEntity.ok(Map.of("fulfillmentText", "Faltan datos para crear la reserva. Asegúrate de indicar la sede, fecha y hora."));
            }

            try {
                OffsetDateTime fechaOffset = OffsetDateTime.parse(fechaStr);
                OffsetDateTime horaOffset = OffsetDateTime.parse(horaStr);

                LocalDate fecha = fechaOffset.toLocalDate();
                LocalTime hora = horaOffset.toLocalTime();

                System.out.println("✅ Fecha normalizada: " + fecha);
                System.out.println("✅ Hora normalizada: " + hora);
                System.out.println("✅ Sede corregida: " + sede);

                HorarioAtencion.DiaSemana diaSemana = switch (fecha.getDayOfWeek()) {
                    case MONDAY    -> HorarioAtencion.DiaSemana.Lunes;
                    case TUESDAY   -> HorarioAtencion.DiaSemana.Martes;
                    case WEDNESDAY -> HorarioAtencion.DiaSemana.Miércoles;
                    case THURSDAY  -> HorarioAtencion.DiaSemana.Jueves;
                    case FRIDAY    -> HorarioAtencion.DiaSemana.Viernes;
                    case SATURDAY  -> HorarioAtencion.DiaSemana.Sábado;
                    case SUNDAY    -> HorarioAtencion.DiaSemana.Domingo;
                };

                Optional<HorarioDisponible> horarioOpt = horarioDisponibleRepository
                        .buscarHorarioDisponible(sede, hora, diaSemana);

                if (horarioOpt.isEmpty()) {
                    return ResponseEntity.ok(Map.of("fulfillmentText", "No se encontró un horario disponible para la hora indicada."));
                }

                HorarioDisponible horario = horarioOpt.get();
                Estado estado = estadoRepository.findById(1).orElseThrow(); // Estado PENDIENTE

                // Obtener sede y servicio a partir del horario
                Optional<Sede> sedeOpt = sedeRepository.findByNombre(sede);
                if (sedeOpt.isEmpty()) {
                    return ResponseEntity.ok(Map.of("fulfillmentText", "No se encontró la sede con el nombre proporcionado."));
                }
                Sede sedeEntity = sedeOpt.get();

                Servicio servicio = horario.getServicio();

                Optional<SedeServicio> sedeServicioOpt = sedeServicioRepository.findBySedeAndServicio(sedeEntity, servicio);
                if (sedeServicioOpt.isEmpty()) {
                    return ResponseEntity.ok(Map.of("fulfillmentText", "No se encontró la relación entre la sede y el servicio."));
                }

                Reserva nuevaReserva = new Reserva();
                nuevaReserva.setUsuario(usuario);
                nuevaReserva.setHorarioDisponible(horario);
                nuevaReserva.setFechaReserva(fecha);
                nuevaReserva.setEstado(estado);
                nuevaReserva.setSedeServicio(sedeServicioOpt.get());

                reservaRepository.save(nuevaReserva);

                return ResponseEntity.ok(Map.of("fulfillmentText", "✅ ¡Reserva registrada con éxito para el " + fecha + " a las " + hora + "!"));
            } catch (Exception e) {
                e.printStackTrace();
                return ResponseEntity.ok(Map.of("fulfillmentText", "❌ Error al crear la reserva: " + e.getMessage()));
            }
        }




        // ----- INTENT desconocido -----
        return ResponseEntity.ok(Map.of("fulfillmentText", "No entendí tu solicitud. Puedes preguntarme por servicios, canchas disponibles o tus reservas."));
    }
}
