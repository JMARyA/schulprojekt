#set document(
  title: "Pocket Surf - Projektdokumentation",
  author: "Erion Sahitaj, Angelo Rodriguez, Matthias Holme",
  date: datetime(year: 2026, month: 2, day: 10),
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
      10.02.2026
    ]
  },
)

#set text(
  font: "Arial",
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

  #image("bs_lau.jpg", width: 40%)

  #v(1fr)

  *Team-Mitglieder:*\
  Erion Sahitaj\
  Angelo Rodriguez\
  Matthias Holme

  #v(1cm)
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
- Jede Komponente wird entwickelt und integriert.

== Testing
- Zusammensetzen aller Module und Testen des Gesamtsystems.
- Ziel: Fehler erkennen und beheben.

== Installation
- Software wird in der Zielumgebung installiert und produktiv eingesetzt.

== Maintenance
- Beheben von Fehlern, Updates, Anpassungen.

#v(1em)

#block(
  fill: gray.lighten(80%),
  inset: 10pt,
  radius: 4pt,
  [
    *Hinweis:* Da es sich hier um ein Schulprojekt handelt, wird die Software und das System an sich niemals produktiv im Unternehmenskontext eingesetzt. Wir nehmen den Begriff dennoch her, um nach einer erfolgreichen Testing-Phase den Zustand des Systems entsprechend als „Einsatzbereit" zu definieren.
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
  [Prozessor], [Quad Core ARM-CPU (energieeffizient)],
  [Speicher], [M.2 SSD mit HAT],
  [Stromversorgung], [PowerBank (10.000 mAh, 15W)],
  [Stromverbrauch], [3-18W (durchschnittlich 13W)],
  [Konnektivität], [Wi-Fi, Ethernet, USB],
)

== Betriebssystem

Für das Betriebssystem haben wir uns bewusst für Raspberry Pi OS entschieden, da es eine umfassende Sammlung nützlicher Tools für die Administration eines Raspberry Pi bereitstellt. Alternativen wie beispielsweise Alpine Linux wären ebenfalls denkbar gewesen, bieten jedoch häufig nicht alle erforderlichen Utilities, die für eine effiziente Systemverwaltung hilfreich sind. Raspberry Pi OS stellt hingegen unter anderem Software bereit, die ein einfaches und sicheres Aktualisieren der Firmware des Geräts ermöglicht. Die Vielzahl dieser praktischen Programme macht Raspberry Pi OS im Hinblick auf Kompatibilität somit zu einer besonders attraktiven Wahl für den Einsatz auf dem Raspberry Pi.

== Software

=== Geplante Dienste

Der Software-Stack konzentriert sich auf essenzielle Business-Funktionen, die auch ohne Internet-Anbindung vollständig nutzbar sind. Alle Dienste sind ressourcenschonend und für den mobilen Betrieb optimiert.

==== Home App
Zentrale Verwaltungsoberfläche:
- Übersicht über alle installierten Services / Home Menu
- WLAN-Hotspot-Verwaltung
- Geräte Administration

==== SFTPGo (File Server)
Dateiablage und -austausch:
- Zentrale Ablage für Dokumente und Backups
- Web-Interface für Dateimanagement
- WebDAV-Zugriff für Desktop/Mobile
- Datenaustausch zwischen Geräten / Sharing

==== Vikunja (Task Management)
Projektmanagement und Aufgabenverwaltung:
- Kanban-Boards und Listen
- Zeiterfassung und Deadlines
- Team-Koordination
- Funktioniert vollständig offline und eigenständig

==== Local Chat (Messaging)
Messaging-Dienst für lokale Kommunikation:
- Echtzeit-Chat
- Team-Kommunikation ohne Internet
- Dateifreigabe möglich
- Gruppenchats

==== BookStack (Knowledge Base)
Wissens- und Dokumentationsdatenbank:
- Strukturierte Dokumentation von Prozessen und Wissen
- Markdown-Editor mit WYSIWYG-Option
- Suchfunktion über alle Dokumente
- Versionierung von Änderungen
- Wichtig für Business: Prozessdokumentation, Knowledge, Anleitungen

=== Systemdienste

==== Dnsmasq (DNS/DHCP)
Netzwerk-Infrastruktur fürs lokale Netz:
- DHCP-Server für automatische IP-Vergabe
- DNS-Server für lokale Namensauflösung
- Ermöglicht Betrieb als eigenständiger WLAN-Hotspot
- Interne DNS-Umschreibung für Service-Namen (z.B. `files.local`)

==== Caddy (Reverse Proxy)
Zentraler Reverse Proxy und Webserver:
- Einheitlicher Einstiegspunkt für alle Dienste
- Automatisches Routing zu verschiedenen Anwendungen via DNS-Namen
- HTTPS-Unterstützung mit selbstsignierten Zertifikaten
- Koordiniert alle Web-Dienste über Port 80/443
- Benutzerfreundliche URLs: `home.local`, `files.local`, `tasks.local`, `wiki.local`, etc.
- Vereinfacht Zugriff: Keine IP-Adressen und Port-Nummern mehr notwendig

#pagebreak()

= Projektdurchführung

== Erstes Anschalten

Zunächst musste das OS auf die M.2 SSD geschrieben werden, da der RP standardmäßig nicht über einen USB-Stick oder dergleichen booten kann. Das passierte mit dem Raspberry Pi Imager. Dieser kann eine Auswahl an vorgefertigten Betriebssystemen auf einen gewünschten Speicher schreiben. In unserem Fall die M.2 SSD. Nachdem die SSD mit Raspberry Pi OS beschrieben worden ist, konnte diese auf dem HAT montiert werden. Der HAT wurde anschließend auf dem RP verbaut und entsprechend angeschlossen.

Nun gibt es aber das Problem, dass der RP immer noch nicht automatisch von der SSD booten kann, da dies eine neuere Firmwareversion erfordert und einige Kompatibilitätsprobleme aufgetreten sind. So haben wir nach dem Einbau einer SSD trotzdem zunächst von einer SD-Karte mit Raspberry Pi OS gebootet, um die Firmware mit dem mitgelieferten Tool `rpi-eeprom-update` zu upgraden.

Nachdem das Upgrade erfolgreich durchgeführt wurde, konnte der RP ohne weitere Konfiguration und ohne SD-Karte direkt von der M.2 SSD booten.

== Erste OS-Konfiguration

Die erste Konfiguration wurde ganz klassisch mit angeschlossenem Monitor, Maus und Tastatur durchgeführt. Da das aber viel Platz einnimmt und unpraktisch ist, haben wir zunächst SSH installiert und konfiguriert. Für die SSH-Anwendung haben wir uns hierbei für OpenSSH entschieden. Nachdem der SSH-Zugang konfiguriert wurde, konnten wir die restlichen Einstellungen bequem per SSH vornehmen, ohne das ganze Equipment dabei zu haben. Durch die anfangs endstandenen Kompatibilitätsprobleme haben wir uns kurzzeitig auch überlegt, das System im vorhinein innerhalb einer virtuellen Maschine zu testen, bevor wir es auf den RP ausrollen.

== Netzwerkkonfiguration

Die Netzwerkkonfiguration des Pocket Surf basiert auf drei Hauptkomponenten, die zusammen einen vollständig autonomen WLAN-Hotspot mit integriertem Services bereitstellen.

=== Netzwerkarchitektur

Der Raspberry Pi fungiert als eigenständiger Access Point. Clients verbinden sich über das WiFi-Netzwerk "PocketSurf" und erhalten automatisch eine IP-Adresse und Zugriff auf das interne Netzwerk.

=== Komponenten

==== hostapd - WiFi Access Point
Erstellt den WLAN-Hotspot auf dem `wlan0`-Interface:
- SSID: PocketSurf
- Sicherheit: WPA3
- Kanal: 7 (2.4 GHz)

==== dnsmasq - DHCP und DNS Server
Stellt zwei essenzielle Netzwerkdienste bereit:

*DHCP-Server:* Weist Clients automatisch IP-Adressen zu.

*DNS-Server:* Löst lokale `.local`-Domains auf und leitet sie an den Server weiter:
- `home.local`
- `files.local`
- `tasks.local`
- `wiki.local`
- `chat.local`

==== Caddy - Reverse Proxy
Routet eingehende HTTP/HTTPS-Anfragen zu den jeweiligen Backend-Services:

#table(
  columns: (auto, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
  align: left,
  [*Domain*], [*Service*],
  [home.local], [Home Menu],
  [files.local], [SFTPGo],
  [tasks.local], [Vikunja],
  [wiki.local], [BookStack],
  [chat.local], [Chat],
)

== Service-Installation und -Konfiguration

=== Implementierung

Alle Konfigurationsdateien der Server Implementierung:
- `hostapd.conf` - WiFi-Hotspot-Konfiguration
- `dnsmasq.conf` - DHCP- und DNS-Konfiguration
- `Caddyfile` - Reverse-Proxy-Routing
- `quadlets/` - Ordner mit Container Dateien für die Services
- `install.sh` - Installations-Script

Die Installation des Systems erfolgt über das bereitgestellte Shell-Script, welches alle notwendigen Pakete installiert, Konfigurationen deployed und die Services aktiviert.

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

Die Aufgaben wurden gleichmäßig auf die drei Teammitglieder verteilt, wobei jedes Mitglied einen spezifischen Verantwortungsbereich übernahm:

=== Matthias Holme - System Design und Integration

*Verantwortungsbereich:*
- Gesamtsystem-Architektur und Design
- Hardware-Setup und Konfiguration
  - Raspberry Pi 5 Einrichtung
  - M.2 SSD Installation und Firmware-Updates
  - PowerBank-Integration
- Netzwerk-Infrastruktur
  - hostapd Konfiguration
  - dnsmasq DHCP/DNS-Setup
- Container-Orchestrierung
  - Podman-Quadlets Implementierung
  - Systemd-Integration
  - Service-Management
- Systemintegration und Testing
  - Sicherstellung der Zusammenarbeit aller Komponenten
  - Performance-Optimierung
  - Installations-Scripts

=== Angelo Rodriguez - Home Dashboard & UI

*Verantwortungsbereich:*
- Home Dashboard Entwicklung
  - Rust + Actix Web Backend
  - Maud HTML Templates
  - HTMX-Integration
  - Apple-inspiriertes UI-Design
- Konfigurationsverwaltung
  - WiFi-Hotspot-Einstellungen
  - Programmatische Verwaltung der Systemkonfiguration
  - Integration mit hostapd.conf
- Frontend-Design
  - CSS-Styling und Animationen
  - Responsive Design
  - UX-Optimierung
- Enge Zusammenarbeit mit Matthias
  - Integration der UI mit dem System
  - Testing der Konfigurationsschnittstellen

=== Erion Sahitaj - Chat-Anwendung

*Verantwortungsbereich:*
- Design und Implementierung der lokalen Chat-Anwendung
  - Architektur der Chat-Lösung
  - Backend-Entwicklung
  - Frontend-Interface
- Funktionen
  - Echtzeit-Messaging
  - Offline-First Design
  - Dateifreigabe
  - Gruppenchats
- Container-Integration
  - Dockerfile und Deployment
  - Integration in die Pocket-Surf-Infrastruktur

=== Gemeinsame Aufgaben

- Dokumentation (Typst-Dokumente)
- Präsentationsvorbereitung
- Testing und Qualitätssicherung
- Code-Reviews und gegenseitige Unterstützung

== Herausforderungen und Lösungen

// TODO : Überarbeiten, Reality Check

=== SSD-Kompatibilitätsprobleme mit dem M.2 HAT

*Herausforderung:*

Eine der größten Herausforderungen während der Hardware-Konfiguration war die Kompatibilität der M.2 SSDs mit dem Raspberry Pi M.2 HAT. Zunächst stellten wir fest, dass zwei verschiedene SSDs, die wir testen wollten, nicht mit dem HAT kompatibel waren. Die SSDs wurden vom System nicht erkannt oder führten zu Bootproblemen.

*Probleme im Detail:*
- Erste SSD wurde vom Raspberry Pi nicht erkannt
- Zweite SSD führte zu instabilem Bootverhalten
- Firmware des Raspberry Pi war nicht aktuell genug für M.2 SSD-Boot
- Kompatibilitätsprobleme zwischen HAT und bestimmten SSD-Modellen

*Lösungsansatz:*
1. *Firmware-Update:* Zunächst wurde die Raspberry Pi Firmware mit `rpi-eeprom-update` auf die neueste Version aktualisiert, um grundlegende M.2-Boot-Unterstützung zu gewährleisten.

2. *SSD-Kompatibilitätstests:* Systematisches Testen verschiedener SSD-Modelle, um ein kompatibles Modell zu identifizieren.

3. *Recherche:* Überprüfung der offiziellen Raspberry Pi HAT-Kompatibilitätslisten und Community-Erfahrungen.

4. *Erfolgreiche Lösung:* Nach mehreren Versuchen fanden wir eine kompatible SSD, die nach dem Firmware-Update stabil funktionierte.

*Erkenntnisse:*
- Hardware-Kompatibilität kann nicht vorausgesetzt werden, selbst bei standardisierten Schnittstellen wie M.2
- Firmware-Updates sind essentiell für neuere Hardware-Features
- Ausreichende Vorab-Recherche über Kompatibilität spart Zeit und Frustration
- Ein Backup-Plan mit alternativen Hardware-Komponenten ist wichtig

=== Netzwerk-Isolation und Container-Kommunikation

*Herausforderung:*

Die Konfiguration der Podman-Container zur Kommunikation untereinander und gleichzeitig die korrekte Weiterleitung durch Caddy stellte eine technische Herausforderung dar.

*Lösung:*

Verwendung eines Podman-Pods mit gemeinsamem Netzwerk-Namespace. Dadurch können alle Container über `localhost` miteinander kommunizieren, während die Host-Netzwerk-Services (hostapd, dnsmasq) weiterhin funktionieren.

=== WiFi-Hotspot-Stabilität

*Herausforderung:*

Initialer Konfigurationsfehler bei hostapd führte zu instabilen WiFi-Verbindungen.

*Lösung:*

Optimierung der Kanalauswahl (Kanal 7) und korrekte WPA2-Konfiguration. Sicherstellung, dass `wpa_supplicant` nicht mit `hostapd` interferiert durch explizites Deaktivieren in der `dhcpcd.conf`.

#pagebreak()

= Fazit

== Zusammenfassung

// TODO : Zusammenfassung des Projekts

== Lessons Learned

// TODO : Echte Lessons Learned, Nicht Schizo

=== Hardware-Limitierungen

*Raspberry Pi als Proof-of-Concept:*

Der Raspberry Pi 5 mit 8 GB RAM hat sich als ausreichend für einen Proof-of-Concept und für den Einsatz als persönlicher mobiler Server erwiesen. Für den Einsatz in einem echten produktiven Umfeld würde jedoch deutlich leistungsfähigere Hardware benötigt werden:

- *Architektur:* Ein produktives System würde eher auf x86_64-Architektur basieren (z.B. Intel NUC, Mini-PC) statt ARM
  - Bessere Kompatibilität mit Standard-Software
  - Höhere CPU-Leistung für mehrere gleichzeitige Nutzer
  - Mehr RAM-Erweiterbarkeit (16-32 GB+)

- *Leistung:* Der ARM-Prozessor des Raspberry Pi stößt bei mehreren Container-Services an seine Grenzen
  - Längere Build-Zeiten
  - Geringere Performance bei Datenbank-Operationen
  - Eingeschränkte Skalierbarkeit

- *Zuverlässigkeit:* Enterprise-Hardware bietet bessere Zuverlässigkeit und Support
  - ECC-RAM für Datensicherheit
  - Redundante Speicher-Optionen
  - Professioneller Hardware-Support

*Empfehlung für Produktivbetrieb:*

Ein Mini-PC mit x86_64-Architektur, mindestens 16 GB RAM, und einer NVMe-SSD wäre für einen Produktiveinsatz besser geeignet. Der Raspberry Pi ist jedoch ideal für:
- Prototyping und Proof-of-Concept
- Persönliche/Hobby-Projekte
- Lernumgebungen
- Geringe Nutzerlast (1-3 Benutzer)

=== Dokumentation ist essentiell

Die ausführliche Dokumentation aller Konfigurationsschritte hat sich als äußerst wertvoll erwiesen:
- Reproduzierbarkeit der Installation
- Fehlersuche vereinfacht
- Wissensvermittlung im Team
- Grundlage für zukünftige Erweiterungen

=== Container-Orchestrierung vereinfacht Deployment

Die Verwendung von Podman mit systemd-Quadlets hat mehrere Vorteile gebracht:
- Einfaches Service-Management
- Automatische Neustarts bei Fehlern
- Klare Trennung der Services
- Vereinfachte Updates einzelner Komponenten

=== Offline-First Design erfordert Planung

Die Anforderung, dass alle Services offline funktionieren müssen, erforderte bewusste Technologie-Entscheidungen:
- Verwendung von SQLite statt externen Datenbanken
- Keine Abhängigkeiten von CDNs
- Lokale Authentifizierung
- Eingebettete Assets

=== Hardware-Kompatibilität prüfen

Die SSD-Kompatibilitätsprobleme haben gezeigt, dass auch bei standardisierten Schnittstellen Kompatibilitätsprobleme auftreten können. Vor dem Kauf sollte:
- Community-Feedback überprüft werden
- Kompatibilitätslisten konsultiert werden
- Testphasen eingeplant werden
- Backup-Optionen vorgehalten werden

#pagebreak()

= Anhang

== Anhang A: Quellcode-Auszüge

// TODO : Code-Snippets hier einfügen

== Anhang B: Konfigurationsdateien

// TODO : Konfigurationsdateien hier dokumentieren

== Anhang C: Zusätzliche Dokumentation

// TODO : Zusätzliche Dokumentation hier einfügen
