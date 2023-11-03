/*
Este programa en java es de la asignatura de programación en la que se ponen los distintos atributos que se ven abajo
para luego en otro archivo poner la marca, modelo, cilindrada y color de 2 coches distintos.
 */
package coche;

/**
 *
 * @author elias
 */
public class Coche {

    //atributos
    String color;
    String marca;
    String modelo;
    double cilindrada;
    boolean enMarcha;

    //constructor
    public Coche(String color, String marca, String modelo, double cilindrada) {
        this.color = color;
        this.marca = marca;
        this.modelo = modelo;
        this.cilindrada = cilindrada;
        this.enMarcha = false; // El coche comienza apagado
    }

    //encednder coche
    public void encender() {
        enMarcha = true;
        System.out.println("El coche esta encendido. ");
    }

    public void acelerar() {
        if (enMarcha) {
            System.out.println("El coche esta aclerando. ");
        } else {
            System.out.println("El coche esta parado");
        }

    }

    public void frenar() {
        if (enMarcha) {
            System.out.println("el coche esta frenando");
        } else {
            System.out.println("El coche no esta encendido");
        }
    }

    // Método para imprimir el modelo y la marca del coche
    public void imprimirModeloyMarca() {
        System.out.println("Modelo: " + modelo);
        System.out.println("Marca: " + marca);
    }
    

}







