package com.example.grupo_6.Entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalTime;
import java.util.Base64;

@Entity
@Table(name = "servicio")
@Data
public class Servicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idservicio;

    private String nombre;

    private String descripcion;

    @ManyToOne
    @JoinColumn(name = "idtipo", nullable = false)
    private TipoServicio tipoServicio;


    @ManyToOne
    @JoinColumn(name = "idestado", nullable = false)
    private Estado estado;

    @Column(name = "contacto_soporte")
    private String contactoSoporte;

    @Column(name = "horario_inicio")
    private LocalTime horarioInicio;

    @Column(name = "horario_fin")
    private LocalTime horarioFin;


}
