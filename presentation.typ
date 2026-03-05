#set page(
  paper: "presentation-16-9",
  margin: (x: 2em, y: 2em),
  footer: context {
    set text(size: 12pt, fill: gray)
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [Pocket Surf - Mobiler Server],
      if counter(page).get().first() > 1 [
        #counter(page).display("1")
      ]
    )
  }
)

#set text(font: "DejaVu Sans", size: 22pt, lang: "de")
#set par(justify: false, leading: 0.8em)

// Color definitions
#let primary = rgb("#2c3e50")
#let accent = rgb("#3498db")
#let light-bg = rgb("#ecf0f1")

// Helper function for slide titles
#let slide-title(content) = {
  block(
    width: 100%,
    inset: (bottom: 0.5em),
    stroke: (bottom: 3pt + accent),
    text(size: 32pt, weight: "bold", fill: primary)[#content]
  )
  v(1em)
}

// ===== TITLE SLIDE =====
#align(center + horizon)[
  #text(size: 52pt, weight: "bold", fill: primary)[
    Pocket Surf
  ]

  #v(1em)

  #text(size: 36pt, fill: accent)[
    Mobiler Server für Unterwegs
  ]

  #v(2em)

  #text(size: 20pt)[
    Schulprojekt Berufsschule Lauingen 2026
  ]

  #v(1em)

  #text(size: 18pt, fill: gray)[
    Erion Sahitaj • Angelo Rodriguez • Matthias Holme
  ]
]

#pagebreak()

// ===== SLIDE 2: Projektübersicht =====
#slide-title[Projektübersicht]

*Ziel:* Kompakter, mobiler Server für Offline-Betrieb

#v(1em)

*Einsatzszenarien:*
- Unterwegs ohne feste Infrastruktur
- Disaster Recovery
- Mobile Geschäftsanwendungen
- Offline-First Computing

#v(1em)

*Kernkonzept:* Alle wichtigen Services in der Hosentasche

#pagebreak()

// ===== SLIDE 3: Hardware =====
#slide-title[Hardware]

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    *Komponenten:*
    - Raspberry Pi 5 (8 GB RAM)
    - M.2 SSD mit HAT
    - PowerBank (10.000 mAh)
    - WiFi integriert
  ],
  [
    *Vorteile:*
    - Kompakt und mobil
    - Energieeffizient (13W Ø)
    - Mehrere Stunden Laufzeit
    - Standard-Hardware
  ]
)

#v(2em)

#align(center)[
  #text(size: 18pt, fill: gray, style: "italic")[
    Pocket-sized, aber leistungsfähig
  ]
]

#pagebreak()

// ===== SLIDE 4: Software-Stack =====
#slide-title[Software-Stack]

*Betriebssystem:* Raspberry Pi OS

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    *User Services:*
    - Dashboard (Home)
    - SFTPGo (Files)
    - Vikunja (Tasks)
    - BookStack (Wiki)
    - Local Chat
  ],
  [
    *System Services:*
    - hostapd (WiFi AP)
    - dnsmasq (DNS/DHCP)
    - Caddy (Reverse Proxy)
  ]
)

#v(1.5em)

#text(size: 20pt, fill: accent, weight: "bold")[
  → Alles offline-fähig und local-first
]

#pagebreak()

// ===== SLIDE 5: Netzwerk-Architektur =====
#slide-title[Netzwerk-Architektur]

#align(center)[
  #block(
    fill: light-bg,
    inset: 1.5em,
    radius: 8pt,
    width: 85%,
  )[
    #set text(size: 18pt, font: "DejaVu Sans Mono")
    #set align(left)
    ```
    Client verbindet sich
         ↓
    WiFi: "PocketSurf"
         ↓
    IP: 192.168.4.x (DHCP)
         ↓
    DNS: *.local → 192.168.4.1
         ↓
    Caddy Reverse Proxy
         ↓
    ┌──────────┬──────────┬──────────┐
    home.local files.local tasks.local
    ```
  ]
]

#v(1em)

#text(size: 20pt, weight: "bold")[
  *Resultat:* Benutzerfreundliche URLs ohne Ports!
]

#pagebreak()

// ===== SLIDE 6: Implementierung =====
#slide-title[Implementierung]

*Schritte:*

#v(0.5em)

*1. Hardware-Setup*
  - Firmware-Update für SSD-Boot
  - M.2 SSD als Hauptspeicher

*2. OS-Installation*
  - Raspberry Pi OS via Imager
  - SSH-Konfiguration

*3. Netzwerk-Stack*
  - hostapd + dnsmasq + Caddy
  - Automatisches Install-Script

*4. Service-Deployment*
  - Container-basierte Services
  - Zentrale Verwaltung via Dashboard

#pagebreak()

// ===== SLIDE 7: Herausforderungen =====
#slide-title[Besondere Herausforderungen]

*SSD-Boot:* RP5 benötigt Firmware-Update
  #text(size: 18pt, fill: gray)[→ Temporärer Boot von SD-Karte nötig]

#v(0.8em)

*Offline-Betrieb:* Alle Services ohne Internet
  #text(size: 18pt, fill: gray)[→ Konsequentes Local-First Design]

#v(0.8em)

*Benutzerfreundlichkeit:* Keine Port-Nummern
  #text(size: 18pt, fill: gray)[→ DNS-Rewrites + Reverse Proxy]

#v(0.8em)

*Energieeffizienz:* Lange Laufzeit auf Akku
  #text(size: 18pt, fill: gray)[→ PowerBank min. 15W Dauerleistung]

#pagebreak()

// ===== SLIDE 8: Use Cases =====
#slide-title[Use Cases]

*Praktische Anwendungen:*

#v(0.5em)

*Baustelle/Außendienst*
  Zugriff auf Pläne, Dokumentation, Kommunikation

#v(0.5em)

*Events/Messen*
  Lokales Netzwerk für Team ohne Internet-Abhängigkeit

#v(0.5em)

*Disaster Recovery*
  Backup wichtiger Daten und Zugangsinformationen

#v(0.5em)

*Mobile Büros*
  Vollständige Office-Umgebung in der Tasche

#pagebreak()

// ===== SLIDE 9: Demo =====
#slide-title[Demo]

#v(2em)

#align(center)[
  #text(size: 48pt, fill: accent, weight: "bold")[
    Live Demo
  ]

  #v(2em)

  #text(size: 26pt)[
    1. Mit "PocketSurf" verbinden

    2. Browser öffnen: `home.local`

    3. Services ausprobieren
  ]
]

#pagebreak()

// ===== SLIDE 10: Fazit =====
#slide-title[Fazit]

*Erreichte Ziele:*
- ✓ Voll funktionsfähiger mobiler Server
- ✓ Offline-first Design
- ✓ Benutzerfreundliche Bedienung
- ✓ Lange Akkulaufzeit

#v(1em)

*Lessons Learned:*
- Hardware-Besonderheiten (Firmware-Updates)
- Netzwerk-Stack Komplexität
- Wichtigkeit von guter Dokumentation

#v(1em)

#text(size: 20pt, fill: accent, weight: "bold")[
  → Praktikable Lösung für mobile Arbeitsszenarien
]

#pagebreak()

// ===== FINAL SLIDE =====
#align(center + horizon)[
  #text(size: 52pt, weight: "bold", fill: primary)[
    Vielen Dank!
  ]

  #v(2em)

  #text(size: 28pt)[
    Fragen?
  ]

  #v(2em)

  #text(size: 18pt, fill: gray)[
    Erion Sahitaj • Angelo Rodriguez • Matthias Holme
  ]
]
