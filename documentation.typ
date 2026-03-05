#set document(
  title: "Pocket Surf - Projektdokumentation",
  author: "Team Pocket Surf",
  date: auto,
)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: gray)
      #smallcaps[Pocket Surf - Projektdokumentation]
      #h(1fr)
      #datetime.today().display("[day].[month].[year]")
    ]
  },
)

#set text(
  font: "DejaVu Sans",
  size: 11pt,
  lang: "de",
)

#set heading(numbering: "1.1")

#set par(
  justify: true,
  leading: 0.65em,
)

// Title Page
#align(center)[
  #v(2cm)

  #text(size: 28pt, weight: "bold")[
    Pocket Surf
  ]

  #v(0.5cm)

  #text(size: 18pt)[
    Mobiler Server
  ]

  #v(1cm)

  #text(size: 14pt)[
    Projektdokumentation
  ]

  #v(0.5cm)

  #text(size: 12pt)[
    Schulprojekt Berufsschule Lauingen 2026
  ]

  #v(2cm)

  // #image("logo.png", width: 40%)
  // Uncomment above line if you have a logo

  #v(1fr)

  *Team-Mitglieder:*\
  Erion Sahitaj\
  Angelo Rodriguez\
  Matthias Holme
]

#pagebreak()

// Table of Contents
#outline(
  title: [Inhaltsverzeichnis],
  indent: auto,
)

#pagebreak()

= Abkürzungsverzeichnis

#table(
  columns: (auto, 1fr),
  stroke: none,
  align: left,
  [*MS*], [Mobiler Server],
  [*OS*], [Operating System],
  [*FOSS*], [Free Open-Source Software],
  [*RAM*], [Random Access Memory],
  [*SSD*], [Solid State Drive],
  [*RP*], [Raspberry Pi],
  [*HAT*], [Hardware Attached on Top],
)

#pagebreak()

= Zweck und Zielsetzung des Dokuments

Ziel dieses Dokuments ist es, die genaue Vorgehensweise der folgenden Phasen des Projekts zu erläutern. Um die Entwicklung strukturiert zu gestalten, haben wir uns hier das Wasserfallmodell zur Hand genommen. Dieses schaut wie folgt aus:

== Requirements and Analysis
- Sammeln und Dokumentieren aller Anforderungen an das System.
- Ziel: Ein vollständiges Verständnis dessen, was das System tun soll.

== System Design
- Entwurf der Architektur und der Komponenten des Systems.
- Entscheidungen über Programmiersprachen, des Betriebssystems usw.

== Implementation
- Programmieren der Software gemäß dem Design.
- Jede Komponente wird entwickelt und getestet (Unit Testing).

== Testing
- Zusammensetzen aller Module und Testen des Gesamtsystems.
- Ziel: Fehler erkennen und beheben.

== Installation
- Software wird in der Zielumgebung installiert und produktiv\* gesetzt.

== Maintenance
- Beheben von Fehlern, Updates, Anpassungen an neue Anforderungen.

#v(1em)

#block(
  fill: gray.lighten(80%),
  inset: 10pt,
  radius: 4pt,
  [
    *\*Hinweis:* Da es sich hier um ein Schulprojekt handelt, wird die Software und das System an sich niemals produktiv im Unternehmenskontext eingesetzt. Wir nehmen den Begriff dennoch her, um nach einer erfolgreichen Testing-Phase den Zustand des Systems entsprechend als „Einsatzbereit" zu definieren.
  ]
)

#pagebreak()

= Einleitung und Überblick

Im Rahmen dieses Projekts wurde ein mobiler Server auf Basis eines Raspberry Pi 5 mit dem Betriebssystem Raspberry Pi OS konzipiert und umgesetzt. Ziel war es, eine kompakte und flexibel einsetzbare Serverlösung zu entwickeln, die unabhängig von stationärer Infrastruktur betrieben werden kann.

Da es sich hierbei um gängige Hard- und Software handelt, hat man hier die Möglichkeit eine sehr hohe Bandbreite an frei verfügbarer Open-Source-Software (FOSS) zu installieren und zu konfigurieren. Somit sind die Einsatzmöglichkeiten eines solchen Systems fast grenzenlos.

Im Verlauf der Projektdokumentation werden zunächst die technischen Grundlagen erläutert, anschließend die Planung und Umsetzung beschrieben sowie die Konfiguration der eingesetzten Dienste dokumentiert. Abschließend erfolgt eine Bewertung des Projektergebnisses hinsichtlich Funktionalität, Sicherheit und Erweiterbarkeit.

#pagebreak()

= Technische Grundlagen

== Hardware Grundlagen

Als physisches Host-Gerät wurde der Raspberry Pi 5 mit 8 GB RAM gewählt. Der Raspberry Pi 5 ist ein leistungsfähiger Einplatinencomputer (Single Board-Computer), der sich insbesondere für IT- und Embedded-Projekte eignet. Die eingesetzte ARM-CPU zeichnet sich durch hohe Energieeffizienz aus, was den Betrieb in mobilen Anwendungen begünstigt. Mit 8 GB RAM verfügt das System über mehr als ausreichend Arbeitsspeicher, um ein Headless-Setup auch mit vielen Services zuverlässig und performant zu betreiben.

Für die mobile Stromversorgung haben wir uns für eine handelsübliche Powerbank entschieden, da diese günstig und handlich sind und außerdem locker für einige Stunden Betrieb reichen. Zu beachten ist nur, dass die Powerbank um die 15W an Leistung konstant abgeben kann. Das ist wichtig, um einen reibungslosen Betrieb des RP zu gewährleisten.

Als nichtflüchtigen Speicher wählten wir eine M.2 SSD mit einem RP HAT, der auf dem RP befestigt ist und fest verbunden wird, da diese deutlich leistungsfähiger und langlebiger als die gängigen SD-Karten sind. Das steigert die allgemeine Verlässlichkeit und das Abspeichern von Daten auf dem RP läuft deutlich schneller.

=== Hardware-Komponenten im Überblick

#table(
  columns: (auto, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
  align: left,
  [*Komponente*], [*Spezifikation*],
  [Hauptplatine], [Raspberry Pi 5 (8 GB RAM)],
  [Prozessor], [ARM-CPU (energieeffizient)],
  [Speicher], [M.2 SSD mit HAT],
  [Stromversorgung], [PowerBank (10.000 mAh, 15W)],
  [Stromverbrauch], [3-18W (durchschnittlich 13W)],
  [Konnektivität], [Wi-Fi],
)

== Betriebssystem

Für das Betriebssystem haben wir uns bewusst für Raspberry Pi OS entschieden, da es eine umfassende Sammlung nützlicher Tools für die Administration eines Raspberry Pi bereitstellt. Alternativen wie beispielsweise Alpine Linux wären ebenfalls denkbar gewesen, bieten jedoch häufig nicht alle erforderlichen Utilities, die für eine effiziente Systemverwaltung hilfreich sind. Raspberry Pi OS stellt hingegen unter anderem Software bereit, die ein einfaches und sicheres Aktualisieren der Firmware des Geräts ermöglicht. Die Vielzahl dieser praktischen Programme macht Raspberry Pi OS somit zu einer besonders attraktiven Wahl für den Einsatz auf dem Raspberry Pi.

== Software

=== Geplante Dienste

Der Software-Stack konzentriert sich auf essenzielle Business-Funktionen, die auch ohne Internet-Anbindung vollständig nutzbar sind. Alle Dienste sind ressourcenschonend und für den mobilen Betrieb optimiert.

==== Home App (Dashboard & Settings)
Zentrale Verwaltungsoberfläche:
- Übersicht über alle installierten Services
- Systemstatus (CPU, RAM, Speicher, Batterie)
- Gerätekonfiguration ohne Terminal
- WLAN-Hotspot-Verwaltung

==== SFTPGo (File Server)
Dateiablage und -austausch:
- Web-Interface für Dateimanagement
- SFTP-Zugriff für Desktop/Mobile
- Zentrale Ablage für Dokumente und Backups
- Datenaustausch zwischen Geräten

==== Vikunja (Task Management)
Projektmanagement und Aufgabenverwaltung:
- Kanban-Boards und Listen
- Zeiterfassung und Deadlines
- Team-Koordination
- Funktioniert vollständig offline

==== Local Chat (Messaging)
Messaging-Dienst für lokale Kommunikation:
- Echtzeit-Chat ohne externe Server
- Team-Kommunikation bei fehlendem Mobilfunk
- Dateifreigabe möglich
- Gruppenchats

==== BookStack (Knowledge Base)
Wissens- und Dokumentationsdatenbank:
- Strukturierte Dokumentation von Prozessen und Wissen
- Markdown-Editor mit WYSIWYG-Option
- Suchfunktion über alle Dokumente
- Versionierung von Änderungen
- Wichtig für Business: Prozessdokumentation, SOPs, Anleitungen

=== Systemdienste

==== Dnsmasq (DNS/DHCP)
Netzwerk-Infrastruktur für lokales Netz:
- DHCP-Server für automatische IP-Vergabe
- DNS-Server für lokale Namensauflösung
- Ermöglicht Betrieb als eigenständiger WLAN-Hotspot
- Interne DNS-Umschreibung für Service-Namen (z.B. `files.local` → `192.168.x.x`)

==== Caddy (Reverse Proxy)
Zentraler Reverse Proxy und Webserver:
- Einheitlicher Einstiegspunkt für alle Dienste
- Automatisches Routing zu verschiedenen Anwendungen via DNS-Namen
- HTTPS-Unterstützung mit selbstsignierten Zertifikaten
- Koordiniert alle Web-Dienste über Port 80/443
- Benutzerfreundliche URLs: `home.local`, `files.local`, `tasks.local`, `wiki.local`, etc.
- Vereinfacht Zugriff: Keine Port-Nummern mehr notwendig

#pagebreak()

= Projektdurchführung

== Erstes Anschalten

Zunächst musste das OS auf die M.2 SSD geschrieben werden, da der RP standardmäßig nicht über einen USB-Stick oder dergleichen booten kann. Das passierte mit dem Raspberry Pi Imager. Dieser kann eine Auswahl an vorgefertigten Betriebssystemen auf einen gewünschten Speicher schreiben. In unserem Fall die M.2 SSD. Nachdem die SSD mit Raspberry Pi OS beschrieben worden ist, konnte diese auf dem HAT montiert werden. Der HAT wurde anschließend auf dem RP verbaut und entsprechend angeschlossen.

Nun gibt es aber das Problem, dass der RP immer noch nicht automatisch von der SSD booten kann, da dies eine neuere Firmwareversion erfordert. So haben wir nach dem Einbau einer SSD trotzdem zunächst von einer SD-Karte mit Raspberry Pi OS gebootet, um die Firmware mit dem mitgelieferten Tool `rpi-eeprom-update` zu upgraden.

Nachdem das Upgrade erfolgreich durchgeführt wurde, konnte der RP ohne weitere Konfiguration und ohne SD-Karte direkt von der M.2 SSD booten.

== Erste OS-Konfiguration

Die erste Konfiguration wurde ganz klassisch mit angeschlossenem Monitor, Maus und Tastatur durchgeführt. Da das aber viel Platz einnimmt und unpraktisch ist, haben wir zunächst SSH installiert und konfiguriert. Für die SSH-Anwendung haben wir uns hierbei für OpenSSH entschieden. Nachdem der SSH-Zugang konfiguriert wurde, konnten wir die restlichen Einstellungen bequem per SSH vornehmen, ohne das ganze Equipment dabei zu haben.

== Netzwerkkonfiguration

Die Netzwerkkonfiguration des Pocket Surf basiert auf drei Hauptkomponenten, die zusammen einen vollständig autonomen WLAN-Hotspot mit integrierter Service-Discovery bereitstellen.

=== Netzwerkarchitektur

Der Raspberry Pi fungiert als eigenständiger Access Point mit der IP-Adresse `192.168.4.1`. Clients verbinden sich über das WiFi-Netzwerk "PocketSurf" und erhalten automatisch eine IP-Adresse aus dem Bereich `192.168.4.10` bis `192.168.4.50`.

=== Komponenten

==== hostapd - WiFi Access Point
Erstellt den WLAN-Hotspot auf dem `wlan0`-Interface:
- SSID: PocketSurf
- Sicherheit: WPA2
- Kanal: 7 (2.4 GHz)

==== dnsmasq - DHCP und DNS Server
Stellt zwei essenzielle Netzwerkdienste bereit:

*DHCP-Server:* Weist Clients automatisch IP-Adressen zu (192.168.4.10-50)

*DNS-Server:* Löst lokale `.local`-Domains auf und leitet sie an den Server (192.168.4.1) weiter:
- `home.local` → 192.168.4.1
- `files.local` → 192.168.4.1
- `tasks.local` → 192.168.4.1
- `wiki.local` → 192.168.4.1
- `chat.local` → 192.168.4.1

==== Caddy - Reverse Proxy
Routet eingehende HTTP/HTTPS-Anfragen zu den jeweiligen Backend-Services:

#table(
  columns: (auto, auto, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
  align: left,
  [*Domain*], [*Port*], [*Service*],
  [home.local], [3000], [Dashboard],
  [files.local], [8080], [SFTPGo],
  [tasks.local], [3456], [Vikunja],
  [wiki.local], [6875], [BookStack],
  [chat.local], [8000], [Chat],
)

=== Implementierung

Alle Konfigurationsdateien befinden sich im Verzeichnis `server-config/`:
- `hostapd.conf` - WiFi-Hotspot-Konfiguration
- `dnsmasq.conf` - DHCP- und DNS-Konfiguration
- `Caddyfile` - Reverse-Proxy-Routing
- `install.sh` - Automatisiertes Installations-Script

Die Installation erfolgt über das bereitgestellte Shell-Script, welches alle notwendigen Pakete installiert, Konfigurationen deployed und die Services aktiviert.

== Service-Installation und -Konfiguration

// Service-Installation hier dokumentieren

#pagebreak()

= Tests und Validierung

== Testumgebung

// Testumgebung beschreiben

== Testfälle

// Testfälle dokumentieren

== Ergebnisse

// Testergebnisse dokumentieren

#pagebreak()

= Projektmanagement

== Zeitplan

// Gantt-Chart oder Timeline einfügen

== Aufgabenverteilung

// Aufgabenverteilung dokumentieren

== Herausforderungen und Lösungen

// Herausforderungen und deren Lösungen beschreiben

#pagebreak()

= Fazit

== Zusammenfassung

// Zusammenfassung des Projekts

== Lessons Learned

// Gelerntes aus dem Projekt

#pagebreak()

= Anhang

== Anhang A: Quellcode-Auszüge

// Code-Snippets hier einfügen

== Anhang B: Konfigurationsdateien

// Konfigurationsdateien hier dokumentieren

== Anhang C: Zusätzliche Dokumentation

// Zusätzliche Dokumentation hier einfügen
