#set document(
  title: "Pocket Surf - Projektdokumentation",
  author: "Erion Sahitaj, Angelo Rodriguez, Matthias Holme",
  date: datetime(year: 2026, month: 2, day: 10),
)

#set page(
  paper: "a4",
  margin: (
    top: 2cm,
    bottom: 2cm,
    left: 2cm,
    right: 3cm,
  ),
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
  size: 12pt,
  lang: "de",
)


#set par(
  justify: true,
  leading: 0.9em, // approx 1.5 spacing
)

#set heading(
  numbering: "1.",
)

#set page(numbering: none)

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
    Staatliche Berufsschule Lauingen\
    Friedrich-Ebert-Straße 14, 89415 Lauingen a.d. Donau
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
  [*ARM*], [Advanced RISC Machine (Prozessorarchitektur)],
  [*CDN*], [Content Delivery Network],
  [*CPU*], [Central Processing Unit],
  [*DHCP*], [Dynamic Host Configuration Protocol],
  [*DNS*], [Domain Name System],
  [*ECC*], [Error-Correcting Code],
  [*FOSS*], [Free Open-Source Software],
  [*HAT*], [Hardware Attached on Top],
  [*HTTP*], [Hypertext Transfer Protocol],
  [*HTTPS*], [Hypertext Transfer Protocol Secure],
  [*IP*], [Internet Protocol],
  [*NVMe*], [Non-Volatile Memory Express],
  [*OS*], [Operating System],
  [*RAM*], [Random Access Memory],
  [*RP*], [Raspberry Pi],
  [*SFTP*], [SSH File Transfer Protocol],
  [*SSH*], [Secure Shell],
  [*SSD*], [Solid State Drive],
  [*SSID*], [Service Set Identifier],
  [*WLAN*], [Wireless Local Area Network],
  [*WPA2*], [Wi-Fi Protected Access 2],
  [*WYSIWYG*], [What You See Is What You Get],
)

#pagebreak()

#counter(page).update(1)

#set page(
  numbering: "1",
  number-align: center,
)

= Zweck und Zielsetzung des Dokuments

Ziel dieses Dokuments ist es, die genaue Vorgehensweise der folgenden Phasen des Projekts zu erläutern. Um die Entwicklung strukturiert zu gestalten, haben wir uns für das Wasserfallmodell entschieden, welches eine sequenzielle Projektdurchführung ermöglicht und klare Phasengrenzen definiert.

== Anforderungsanalyse

In dieser ersten Phase werden alle Anforderungen an das System gesammelt und dokumentiert. Das Ziel ist ein vollständiges Verständnis dessen, was das System leisten soll und welche Funktionen für den mobilen Servereinsatz erforderlich sind.

== Systementwurf

Basierend auf den gesammelten Anforderungen erfolgt der Entwurf der Systemarchitektur und der einzelnen Komponenten. In dieser Phase werden grundlegende Entscheidungen über die einzusetzenden Programmiersprachen, das Betriebssystem und die Netzwerkkonfiguration getroffen.

== Implementierung

In der Implementierungsphase wird die Software gemäß dem zuvor erstellten Design programmiert. Jede Komponente wird einzeln entwickelt und anschließend in das Gesamtsystem integriert.

== Testen

Nach der Implementierung werden alle Module zusammengesetzt und das Gesamtsystem umfassend getestet. Ziel dieser Phase ist es, Fehler zu erkennen und zu beheben, bevor das System in Betrieb genommen wird.

== Inbetriebnahme

Die Software wird in der Zielumgebung installiert und in Betrieb genommen. Alle Dienste werden konfiguriert und auf ihre Funktionsfähigkeit überprüft.

== Wartung

Die letzte Phase umfasst die kontinuierliche Wartung des Systems, einschließlich der Behebung von Fehlern, der Durchführung von Updates und der Anpassung an neue Anforderungen.

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

Da es sich hierbei um gängige Hard- und Software handelt, hat man hier die Möglichkeit, eine sehr hohe Bandbreite an frei verfügbarer Open-Source-Software (FOSS) zu installieren und zu konfigurieren. Somit sind die Einsatzmöglichkeiten eines solchen Systems nahezu unbegrenzt.

Typische Einsatzbereiche für einen mobilen Server dieser Art sind Veranstaltungen und Messen, auf denen kurzfristig eine gemeinsame Infrastruktur benötigt wird, Baustellen und Außenstandorte ohne feste Netzwerkanbindung sowie Workshops und Schulungen, bei denen eine kollaborative Arbeitsumgebung ohne aufwändige Vorbereitung bereitgestellt werden soll.

Im Verlauf der Projektdokumentation werden zunächst die technischen Grundlagen erläutert, anschließend die Planung und Umsetzung beschrieben sowie die Konfiguration der eingesetzten Dienste dokumentiert. Abschließend erfolgt eine Bewertung des Projektergebnisses hinsichtlich Funktionalität, Sicherheit und Erweiterbarkeit.

#pagebreak()

= Technische Grundlagen

== Hardware Grundlagen

Als physisches Host-Gerät wurde der Raspberry Pi 5 mit 8 GB RAM gewählt. Der Raspberry Pi 5 ist ein leistungsfähiger Einplatinencomputer (Single Board-Computer), der sich insbesondere für IT- und Embedded-Projekte eignet. Die eingesetzte ARM-CPU zeichnet sich durch hohe Energieeffizienz aus, was den Betrieb in mobilen Anwendungen begünstigt. Mit 8 GB RAM verfügt das System über mehr als ausreichend Arbeitsspeicher, um ein Headless-Setup auch mit vielen Services zuverlässig und performant zu betreiben.

Für die mobile Stromversorgung haben wir uns für eine handelsübliche Powerbank entschieden, da diese kostengünstig, kompakt und für mehrere Stunden Betrieb ausreichend ist. Zu beachten ist nur, dass die Powerbank mindestens 15W an Leistung konstant abgeben kann. Das ist wichtig, um einen reibungslosen Betrieb des RP zu gewährleisten.

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

=== Dienste

Der Software-Stack konzentriert sich auf essenzielle Geschäftsfunktionen, die auch ohne Internetanbindung vollständig nutzbar sind. Alle Dienste sind ressourcenschonend und für den mobilen Betrieb optimiert.

==== Home App

Die Home App ist die zentrale Verwaltungsoberfläche des Systems. Sie stellt ein Home-Menü mit Übersicht über alle installierten Dienste bereit, ermöglicht die Verwaltung des WLAN-Hotspots und übernimmt grundlegende Geräteadministration.

==== SFTPGo (Dateiserver)

SFTPGo dient als zentraler Dateiserver für Dateiablage und -austausch. Er bietet eine Web-Oberfläche für das Dateimanagement, WebDAV-Zugriff für Desktop- und Mobilgeräte sowie die Möglichkeit, Dateien zwischen Geräten zu teilen. Für Unternehmen eignet er sich als zentrale Ablage für Dokumente und Backups.

==== Vikunja (Aufgabenverwaltung)

Vikunja ist eine Projektmanagement- und Aufgabenverwaltungsanwendung. Sie unterstützt Kanban-Boards, Listen, Zeiterfassung und Deadlines und ist für die Team-Koordination ausgelegt. Die Anwendung funktioniert vollständig offline und ohne externe Abhängigkeiten.

==== Local Chat (Messaging)

Local Chat ist ein Messaging-Dienst für die lokale Kommunikation im Team. Er ermöglicht Echtzeit-Chat und Team-Kommunikation ohne Internetanbindung, unterstützt Gruppenchats und bietet die Möglichkeit zur Dateifreigabe zwischen den Teilnehmern.

==== BookStack (Wissensdatenbank)

BookStack ist eine Wissens- und Dokumentationsdatenbank, die auf strukturierte Dokumentation von Prozessen und Wissen ausgelegt ist. Sie bietet einen Markdown-Editor mit WYSIWYG-Option, eine Suchfunktion über alle Dokumente sowie Versionierung von Änderungen. Für Unternehmen ist sie besonders geeignet für Prozessdokumentation, Wissensmanagement und das Erstellen von Anleitungen.

=== Systemdienste

==== Dnsmasq (DNS/DHCP)

Dnsmasq übernimmt zwei zentrale Aufgaben im lokalen Netz. Als DHCP-Server vergibt es den verbundenen Clients automatisch IP-Adressen und ermöglicht so den eigenständigen Betrieb als WLAN-Hotspot. Als DNS-Server löst es die konfigurierten `.local`-Domains auf die IP-Adresse des Servers auf, sodass alle Dienste über sprechende Namen erreichbar sind.

==== Caddy (Reverse Proxy)

Caddy fungiert als zentraler Reverse Proxy und bildet den einheitlichen Zugangspunkt für alle Web-Dienste. Eingehende Anfragen werden anhand des Domain-Namens an den jeweiligen Backend-Dienst weitergeleitet, sodass alle Anwendungen unter benutzerfreundlichen URLs wie `home.local` oder `files.local` erreichbar sind und keine IP-Adressen oder Port-Nummern bekannt sein müssen. HTTPS wird über Caddys integrierte Zertifikatsverwaltung bereitgestellt, die für jede Domain automatisch ein selbstsigniertes Zertifikat ausstellt. Da diese Zertifikate nicht von einer öffentlich vertrauenswürdigen Zertifizierungsstelle signiert sind, zeigt der Browser beim erstmaligen Aufruf eine Sicherheitswarnung. Dies ist im lokalen Netzwerk jedoch unbedenklich: Der Datenverkehr ist trotz der Warnung verschlüsselt, was gegenüber einer unverschlüsselten HTTP-Verbindung deutlich mehr Sicherheit bietet.

#pagebreak()

=== Technische Grundlagen der Anwendungen

Der Großteil der Anwendungen wird containerisiert in einem gemeinsamen Podman-Pod betrieben. Durch den Einsatz von Containern wird eine klare Isolation zwischen den einzelnen Diensten erreicht. Dies erhöht sowohl die Sicherheit als auch die Wartbarkeit des Systems, da jede Anwendung in einer eigenen, voneinander unabhängigen Umgebung ausgeführt wird.

Ein weiterer Vorteil dieser Architektur besteht darin, dass jede Anwendung ihre eigenen Abhängigkeiten und Laufzeitumgebungen mitbringen kann, ohne Konflikte mit anderen Diensten zu verursachen. Updates oder Änderungen an einem Dienst können somit durchgeführt werden, ohne den Betrieb der übrigen Anwendungen zu beeinträchtigen. Darüber hinaus kann jeder Entwickler die Programmiersprache und die Tools verwenden, die er am besten beherrscht, da die Technologien bei containerisierten Anwendungen frei gewählt werden können und die Interaktion über HTTP standardisiert ist.

Das Home Dashboard stellt hierbei eine Ausnahme dar: Es wird als nativer systemd-Dienst direkt auf dem Host ausgeführt. Da es Konfigurationsdateien des Betriebssystems lesen und schreiben sowie systemd-Dienste wie `hostapd` programmatisch neu starten muss, ist eine enge Integration mit dem Host-System erforderlich, die aus einer containerisierten Umgebung heraus nur mit erheblichem Aufwand realisierbar wäre.

==== Home App

Die Home App stellt die zentrale Verwaltungsoberfläche des Systems dar und dient als Einstiegspunkt für die Benutzer. Sie fungiert als Dashboard, über das alle verfügbaren Dienste erreicht und grundlegende Systemeinstellungen verwaltet werden können.

Die Anwendung wurde in der Programmiersprache Rust implementiert. Rust bietet hohe Ausführungsgeschwindigkeit, sicheres Speichermanagement und ist als Systemsprache extrem ressourcenschonend. Dadurch eignet sich die Sprache besonders gut für Systeme mit begrenzten Ressourcen wie den Raspberry Pi.

Die Home App ist eng mit dem zugrunde liegenden System integriert und übernimmt unter anderem administrative Aufgaben wie die Verwaltung des WLAN-Hotspots sowie grundlegende Geräteadministration. Die Benutzeroberfläche wird als Webanwendung bereitgestellt und besteht aus klassischen Webtechnologien wie HTML und CSS. Dadurch kann die Oberfläche plattformunabhängig über jeden modernen Webbrowser genutzt werden, ohne dass zusätzliche Software auf den Client-Geräten installiert werden muss.

==== Local Chat

Der Messaging-Dienst „Local Chat“ ermöglicht eine direkte Kommunikation zwischen den im lokalen Netzwerk verbundenen Geräten. Da der Dienst vollständig lokal betrieben wird, funktioniert die Kommunikation auch ohne Internetverbindung und eignet sich daher besonders für mobile Events.

Die Anwendung wurde in Python unter Verwendung des Webframeworks Flask entwickelt. Flask ist ein leichtgewichtiges Framework, das sich besonders für kleinere Webanwendungen und APIs eignet. Durch seine modulare Struktur ermöglicht es eine übersichtliche Implementierung der notwendigen Serverlogik.

Für die Echtzeitkommunikation zwischen den Clients werden WebSockets eingesetzt, die eine bidirektionale, dauerhaft offene Verbindung zwischen Client und Server ermöglichen, wodurch Nachrichten unmittelbar an alle verbundenen Teilnehmer verteilt werden können. Neben einfachen Textnachrichten unterstützt der Dienst auch Gruppenchats sowie den Austausch von Dateien zwischen den Nutzern.

Die Benutzeroberfläche des Chat-Systems wird ebenfalls als Webanwendung bereitgestellt und kann über den Browser aufgerufen werden. Dadurch ist keine separate Installation auf den Endgeräten erforderlich, was die Nutzung insbesondere in heterogenen Umgebungen mit verschiedenen Betriebssystemen vereinfacht.

= Projektdurchführung

== Erstes Anschalten

Zunächst musste das OS auf die M.2 SSD geschrieben werden, da der RP standardmäßig nicht über einen USB-Stick oder dergleichen booten kann. Das passierte mit dem Raspberry Pi Imager. Dieser kann eine Auswahl an vorgefertigten Betriebssystemen auf einen gewünschten Speicher schreiben – in unserem Fall auf die M.2 SSD. Nachdem die SSD mit Raspberry Pi OS beschrieben worden ist, konnte diese auf dem HAT montiert werden. Der HAT wurde anschließend auf dem RP verbaut und entsprechend angeschlossen.

Nun gab es aber das Problem, dass der RP immer noch nicht automatisch von der SSD booten konnte, da dies eine neuere Firmwareversion erfordert und einige Kompatibilitätsprobleme aufgetreten sind. So haben wir nach dem Einbau einer SSD trotzdem zunächst von einer SD-Karte mit Raspberry Pi OS gebootet, um die Firmware mit dem mitgelieferten Tool `rpi-eeprom-update` zu upgraden.

Nachdem das Upgrade erfolgreich durchgeführt wurde, konnte der RP ohne weitere Konfiguration und ohne SD-Karte direkt von der M.2 SSD booten.

== Erste OS-Konfiguration

Die erste Konfiguration wurde ganz klassisch mit angeschlossenem Monitor, Maus und Tastatur durchgeführt. Da das aber viel Platz einnimmt und unpraktisch ist, haben wir zunächst SSH installiert und konfiguriert. Für die SSH-Anwendung haben wir uns hierbei für OpenSSH entschieden. Nachdem der SSH-Zugang konfiguriert wurde, konnten wir die restlichen Einstellungen bequem per SSH vornehmen, ohne das ganze Equipment dabei zu haben. Durch die anfangs entstandenen Kompatibilitätsprobleme haben wir uns kurzzeitig auch überlegt, das System zunächst innerhalb einer virtuellen Maschine zu testen, bevor wir es auf den RP ausrollen würden.

== Netzwerkkonfiguration

Die Netzwerkkonfiguration des Pocket Surf basiert auf drei Hauptkomponenten, die zusammen einen vollständig autonomen WLAN-Hotspot mit integrierten Services bereitstellen.

=== Netzwerkarchitektur

Der Raspberry Pi fungiert als eigenständiger Access Point. Clients verbinden sich über das WiFi-Netzwerk "PocketSurf" und erhalten automatisch eine IP-Adresse und Zugriff auf das interne Netzwerk.

=== Komponenten

==== hostapd - WiFi Access Point
Erstellt den WLAN-Hotspot auf dem `wlan0`-Interface:
- SSID: PocketSurf
- Sicherheit: WPA2-PSK
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

=== Systemstruktur

Das System besteht aus zwei Schichten: Diensten, die direkt auf dem Betriebssystem laufen, und containerisierten Anwendungen.

*Host-Dienste* laufen direkt auf dem Betriebssystem, da sie privilegierten Zugriff auf die Netzwerkschnittstelle benötigen:
- `hostapd` stellt den WLAN-Hotspot bereit
- `dnsmasq` übernimmt DHCP-Adressvergabe und lokale DNS-Auflösung
- Das Home Dashboard wird als nativer Systemdienst betrieben, damit es Konfigurationsdateien direkt bearbeiten und Host-Dienste über systemd neu starten kann

*Containerisierte Dienste* laufen in einem gemeinsamen Podman-Pod mit Host-Netzwerkmodus. Im Host-Netzwerkmodus teilen alle Container den Netzwerk-Namespace des Hosts. Das bedeutet, dass alle Dienste über `localhost` miteinander und mit den Host-Diensten kommunizieren können, ohne gesondertes Port-Mapping. Caddy ist damit in der Lage, Anfragen an alle Backends – einschließlich des nativen Home Dashboards – über `localhost` weiterzuleiten.

Die folgende Tabelle gibt einen Überblick über alle Dienste des Systems:

#table(
  columns: (auto, auto, 1fr),
  stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
  align: left,
  [*Dienst*], [*Betrieb*], [*Beschreibung*],
  [Home Dashboard], [Host (systemd)], [Verwaltungsoberfläche; gebaut aus Rust-Quellcode],
  [Caddy], [Container], [Reverse Proxy; leitet Domains zu den jeweiligen Ports weiter],
  [SFTPGo], [Container], [Dateiserver mit Web-Interface und SFTP-Zugang],
  [Vikunja], [Container], [Aufgabenverwaltung mit integriertem Frontend],
  [BookStack], [Container], [Wiki und Wissensdatenbank],
  [MariaDB], [Container], [Datenbankserver für BookStack],
  [Local Chat], [Container], [Echtzeit-Messaging; gebaut aus Python-Quellcode],
)

=== Konfigurationsdateien

Alle Konfigurationsdateien werden während der Installation nach `/etc/pocket-surf/` kopiert:

- `hostapd.conf` — WLAN-Hotspot-Parameter (SSID, Passwort, Kanal, Sicherheit)
- `dnsmasq.conf` — DHCP-Bereich und DNS-Einträge für die `.local`-Domains
- `Caddyfile` — Routing-Regeln des Reverse Proxys

Das Home Dashboard liest und schreibt die Konfigurationsdateien direkt aus diesem Verzeichnis. Nach einer Änderung startet es die betroffenen Host-Dienste über systemd neu, damit die neuen Einstellungen wirksam werden.

=== Container-Definitionen (Quadlets)

Jeder containerisierte Dienst wird durch eine Quadlet-Datei beschrieben. Quadlets sind systemd-Unit-Dateien für Podman-Container: systemd liest die `.container`-Dateien aus `/etc/containers/systemd/` und verwaltet die Container wie reguläre Dienste – inklusive automatischem Neustart bei Fehlern und Aktivierung beim Systemstart.

Abhängigkeiten zwischen Diensten werden über `After=` und `Requires=` in den Unit-Dateien abgebildet. BookStack zum Beispiel startet erst, nachdem die MariaDB-Datenbank bereit ist.

=== Installationsablauf

Die gesamte Installation erfolgt über das Skript `install.sh`. Es durchläuft folgende Schritte:

+ Systempakete installieren: `hostapd`, `dnsmasq` und `podman`
+ Statische IP-Adresse `192.168.4.1` für `wlan0` konfigurieren
+ Konfigurationsdateien nach `/etc/pocket-surf/` deployen; `hostapd` und `dnsmasq` werden so konfiguriert, dass sie ihre Konfiguration aus diesem Verzeichnis lesen
+ IP-Forwarding aktivieren
+ Home Dashboard aus dem Rust-Quellcode bauen (`cargo build --release`), das Binary nach `/usr/local/bin/` installieren und als systemd-Dienst einrichten
+ Host-Dienste (`hostapd`, `dnsmasq`, Home Dashboard) aktivieren und starten
+ Chat-Container aus dem Python-Quellcode bauen (`podman build`) und alle Quadlet-Dateien nach `/etc/containers/systemd/` kopieren
+ Pod und alle Container-Dienste über systemd starten

#pagebreak()

= Tests und Validierung

Die Tests dienen dazu, die grundlegende Funktionsfähigkeit des Systems zu überprüfen sowie die wichtigsten Systemkomponenten und deren Zusammenspiel zu validieren.

Da das System aus mehreren Diensten besteht, die über ein lokales Netzwerk bereitgestellt
werden, ist insbesondere das Zusammenspiel von Netzwerk, Serverdiensten und
Clientgeräten relevant. Ziel der Tests war es daher zu prüfen, ob Benutzer sich mit dem
System verbinden und die bereitgestellten Anwendungen wie vorgesehen nutzen können.

== Testumgebung

Für die Verbindung der Benutzergeräte stellt das System ein eigenes WLAN bereit.
Clientgeräte können sich mit diesem Netzwerk verbinden und anschließend auf die lokal
gehosteten Dienste zugreifen.

Zur Überprüfung der Nutzbarkeit wurden verschiedene Arten von Clientgeräten verwendet.
Dazu gehören Smartphones und Laptops. Diese Geräte unterscheiden sich in Betriebssystem, Bildschirmgröße und Browserumgebung, wodurch sich prüfen lässt, ob die
bereitgestellten Weboberflächen grundsätzlich auf unterschiedlichen Plattformen verwendbar sind.

Die Geräte wurden jeweils mit dem WLAN des Systems verbunden und anschließend über
einen Webbrowser verwendet. Dabei wurde überprüft, ob die bereitgestellten Dienste über
die vorgesehenen lokalen Adressen erreichbar sind und korrekt geladen werden.

== Testdurchführung

Im Rahmen der Tests wurden grundlegende Funktionsprüfungen durchgeführt. Diese
sogenannten Smoke Tests dienen dazu festzustellen, ob die wichtigsten Komponenten eines
Systems grundsätzlich funktionieren und miteinander interagieren können.

Die Tests konzentrieren sich dabei auf drei zentrale Bereiche: Netzwerk, Dienste und
allgemeine Systemnutzung.

=== Netzwerk und Konnektivität

Da sämtliche Anwendungen über ein lokales Netzwerk bereitgestellt werden, bildet die
Netzwerkinfrastruktur die Grundlage für die Nutzung des Systems. Entsprechend wurde
zunächst überprüft, ob Clients sich erfolgreich mit dem WLAN des RP verbinden
können.

Nach erfolgreicher Verbindung wurde kontrolliert, ob die angeschlossenen Geräte eine
gültige IP-Adresse erhalten. Dies geschieht automatisch über einen DHCP-Dienst, der
Teil der Netzwerkkonfiguration des Systems ist. Die korrekte Vergabe von IP-Adressen
ist notwendig, damit Clients innerhalb des lokalen Netzwerks kommunizieren können.

Zusätzlich wurde überprüft, ob die bereitgestellten Dienste über die konfigurierten
lokalen Domains erreichbar sind und das lokale DNS funktioniert. Diese Domains ermöglichen es, die verschiedenen
Webanwendungen über leicht merkbare Adressen aufzurufen, anstatt direkt mit
IP-Adressen zu arbeiten.

Ein weiterer Aspekt der Tests bestand darin, mehrere Geräte gleichzeitig mit dem
Netzwerk zu verbinden. Dadurch konnte überprüft werden, ob grundlegende Mehrbenutzer-
Szenarien funktionieren und die Clients weiterhin auf die bereitgestellten Dienste
zugreifen können.

=== Überprüfung der Dienste

Neben der Netzwerkkonnektivität wurde überprüft, ob die einzelnen Serverdienste korrekt
starten und erreichbar sind. Das System stellt mehrere Webanwendungen bereit, die über
einen Browser genutzt werden können.

Ein zentraler Bestandteil ist das Home Dashboard, das als Einstiegspunkt für die
verschiedenen Dienste dient. Während der Tests wurde überprüft, ob dieses Dashboard
geladen werden kann und die dort hinterlegten Verweise zu den einzelnen Anwendungen
funktionieren.

Darüber hinaus wurden grundlegende Funktionen einzelner Dienste überprüft. Dazu gehört
beispielsweise der Zugriff auf die Benutzeroberflächen der Anwendungen sowie einfache
Interaktionen innerhalb dieser Systeme. Beispiele hierfür sind das Öffnen von
Seiten innerhalb eines Wikis, das Anzeigen von Aufgabenlisten oder der Zugriff auf
Dateibereiche.

Der Zweck dieser Tests war nicht eine vollständige Funktionsprüfung der einzelnen
Anwendungen durchzuführen, sondern sicherzustellen, dass diese korrekt gestartet
werden und grundsätzlich nutzbar sind (Smoke Test/Integration Tests).

=== Allgemeine Nutzung

Ein weiterer Fokus lag auf der praktischen Nutzung des Systems aus Sicht eines
Benutzers. Nachdem ein Clientgerät mit dem Netzwerk verbunden wurde, wurde der
typische Ablauf der Nutzung durchgespielt.

Dabei verbindet sich ein Benutzer zunächst mit dem WLAN des Systems und ruft
anschließend über den Webbrowser das Home Dashboard auf. Von dort aus können die
verschiedenen Dienste geöffnet werden.

Dieser Ablauf wurde mit unterschiedlichen Geräten wiederholt, um zu überprüfen, ob
der Zugriff unabhängig vom verwendeten Gerät grundsätzlich möglich ist. Da sämtliche
Anwendungen webbasiert sind, erfolgt die Nutzung ausschließlich über einen Browser,
wodurch keine zusätzliche Software auf den Clients installiert werden muss.

== Ergebnis

Die durchgeführten Tests zeigen, dass die grundlegenden Funktionen des Systems
bereitgestellt werden können. Clientgeräte konnten sich erfolgreich mit dem WLAN
verbinden und erhielten eine gültige Netzwerkadresse.

Die verschiedenen Webdienste konnten über ihre vorgesehenen lokalen Adressen
aufgerufen werden. Auch das Home Dashboard war erreichbar und konnte als zentraler
Zugangspunkt zu den einzelnen Anwendungen genutzt werden.

Die Nutzung des Systems ist damit grundsätzlich möglich, ohne dass eine Verbindung
zum Internet erforderlich ist. Alle notwendigen Dienste werden lokal auf dem
Raspberry Pi ausgeführt und stehen den verbundenen Clients innerhalb des lokalen
Netzwerks zur Verfügung.

Die Tests bestätigen damit, dass das System in seiner vorgesehenen Grundfunktion
betriebsfähig ist und die wichtigsten Komponenten miteinander zusammenarbeiten.

#pagebreak()

= Projektmanagement

== Aufgabenverteilung

Die Aufgaben wurden gleichmäßig auf die drei Teammitglieder verteilt, wobei jedes Mitglied einen spezifischen Verantwortungsbereich übernahm:

=== Matthias Holme – Systeminfrastruktur und Containerisierung

Bei Matthias Holme lag der Schwerpunkt auf der Systeminfrastruktur. Dazu gehörten die Hardware-Konfiguration des Raspberry Pi 5 einschließlich der M.2 SSD-Installation mit HAT sowie die notwendigen Firmware-Updates. Das Betriebssystem wurde von ihm eingerichtet und konfiguriert. Ein weiterer Schwerpunkt lag auf der Containerisierung des Anwendungs-Stacks:

- Podman-Quadlets für alle containerisierten Dienste
- systemd-Integration und Service-Management
- Installationsskript für die automatisierte Einrichtung des Gesamtsystems

Hardware-Setup, Netzwerkkonfiguration und allgemeine Systemorchestrierung entstanden in enger Zusammenarbeit mit Angelo Rodriguez, da sich die Systemebene und die Anwendungsebene in der Home App direkt überschneiden.

=== Angelo Rodriguez – Home Dashboard und Anwendungsstack

Angelo Rodriguez verantwortete die Entwicklung der Home App sowie die Integration aller Dienste in den Gesamtstack. Die Home App ist eine Webanwendung, die in Rust mit Actix-web als Backend-Framework entwickelt wurde. Die Benutzeroberfläche wurde in HTML und CSS mit einem modernen, responsiven Design umgesetzt.

Ein zentraler Bestandteil ist die Systemverwaltung aus der Anwendung heraus, insbesondere die Verwaltung der WLAN-Konfiguration. Daneben umfasste der Verantwortungsbereich:

- Konfiguration des Reverse Proxys (Caddyfile)
- Container-Integration der einzelnen Dienste in die Gesamtinfrastruktur
- Abstimmung der Schnittstellen zwischen Anwendungs- und Systemebene

Netzwerkkonfiguration und Systemorchestrierung wurden gemeinsam mit Matthias Holme erarbeitet.

=== Erion Sahitaj – Chat-Anwendung

Erion Sahitaj war für die Entwicklung der lokalen Chat-Anwendung zuständig. Die Anwendung wurde in Python mit dem Web-Framework Flask umgesetzt. Für die Echtzeit-Kommunikation zwischen den Clients kommen WebSockets zum Einsatz, über die Nachrichten unmittelbar an alle verbundenen Teilnehmer verteilt werden. Zum Verantwortungsbereich gehörten:

- Backend-Entwicklung und Architektur der Chat-Lösung
- Entwicklung der Browser-basierten Benutzeroberfläche
- Offline-First Design und Dateifreigabe
- Containerisierung mit Dockerfile und Integration in die Pocket-Surf-Infrastruktur

=== Gemeinsame Aufgaben

Dokumentation, Präsentationsvorbereitung, Testing und gegenseitige Code-Reviews wurden gemeinsam von allen drei Teammitgliedern übernommen.

== Herausforderungen und Lösungen

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

=== Lieferkette und Hardwarepreise

*Herausforderung:*

Die Beschaffung der benötigten Hardware gestaltete sich schwieriger als erwartet. Der Raspberry Pi 5 sowie passende M.2 HATs sind auf dem Markt zeitweise nur eingeschränkt verfügbar, was die Projektplanung beeinflusste. Darüber hinaus waren die Preise für die benötigten Komponenten vergleichsweise hoch, sodass das Budget sorgfältig eingeplant werden musste.

*Lösungsansatz:*

Durch frühzeitige Recherche und das Vergleichen verschiedener Anbieter konnten die benötigten Komponenten rechtzeitig beschafft werden. Die Preisentwicklung wurde beobachtet und günstigere Bezugsquellen wurden genutzt, wo dies möglich war.

*Erkenntnisse:*
- Hardware-Projekte erfordern eine frühzeitige Beschaffungsplanung
- Lieferzeiten und Verfügbarkeit können Projektpläne erheblich beeinflussen
- Preisvergleiche und alternative Bezugsquellen sind wichtig, um das Budget einzuhalten

=== Eingeschränkte Betriebssystemwahl

*Herausforderung:*

Die Wahl des Betriebssystems war durch Kompatibilitätsanforderungen eingeschränkt. Viele Dienste und Tools, die wir nutzen wollten, sind primär für x86_64-Architekturen ausgelegt und stehen auf ARM entweder nicht zur Verfügung oder müssen aufwändig angepasst werden. Alternativen wie Alpine Linux schieden aufgrund fehlender Raspberry Pi spezifischer Verwaltungs-Tools aus.

*Lösungsansatz:*

Wir entschieden uns bewusst für Raspberry Pi OS als Betriebssystem, da es den besten Kompromiss aus Kompatibilität, verfügbaren Tools und offizieller Unterstützung für die eingesetzte Hardware bietet. Dienste, die nativ auf ARM verfügbar waren, wurden bevorzugt ausgewählt.

*Erkenntnisse:*
- Die Wahl der Hardware beeinflusst direkt die verfügbaren Software-Optionen
- ARM-Kompatibilität muss bei der Service-Auswahl von Beginn an berücksichtigt werden
- Offizielle und gut gepflegte Betriebssysteme bieten bei spezifischer Hardware klare Vorteile

#pagebreak()

= Fazit

== Zusammenfassung

Das Projekt "Pocket Surf" demonstriert die Entwicklung eines mobilen Servers auf Raspberry Pi Basis. Das System bietet einen autonomen WLAN-Hotspot mit integrierten Business-Services für den Offline-Betrieb.

Die technische Umsetzung kombiniert moderne Container-Technologien (Podman) mit bewährten Netzwerk-Komponenten (hostapd, dnsmasq, Caddy). Das Home Dashboard ermöglicht die einfache Verwaltung des Systems ohne Terminal-Kenntnisse.

Rückblickend betrachten wir das Projekt als Erfolg. Die gesteckten Ziele wurden erreicht: Das System ist betriebsfähig, alle wesentlichen Dienste stehen bereit und lassen sich ohne Internetverbindung nutzen. Besonders positiv war die Zusammenarbeit im Team, bei der jedes Mitglied seinen Schwerpunkt einbringen konnte und die einzelnen Komponenten sich gut zu einem Gesamtsystem zusammengefügt haben.

Die größte persönliche Erkenntnis war, dass Hardwareprojekte deutlich mehr Planungsaufwand erfordern als reine Softwareprojekte. Lieferzeiten, Kompatibilitätsprobleme und Preiserwägungen sind Faktoren, die in der Praxis nicht unterschätzt werden dürfen. Gleichzeitig hat das Projekt gezeigt, dass mit vergleichsweise günstiger Hardware und frei verfügbarer Open-Source-Software eine funktionsfähige und praxistaugliche Serverlösung realisiert werden kann.

== Lessons Learned

=== Hardware-Limitierungen

Der Raspberry Pi 5 mit 8 GB RAM hat sich als ausreichend für einen Proof-of-Concept und für den Einsatz als persönlicher mobiler Server erwiesen. Für den Einsatz in einem echten produktiven Umfeld würde jedoch deutlich leistungsfähigere Hardware benötigt werden.

*Architektur:* Ein produktives System würde eher auf x86_64-Architektur basieren — beispielsweise ein Intel NUC oder ein vergleichbarer Mini-PC — statt auf ARM. Dies bringt bessere Kompatibilität mit Standard-Software mit sich, da viele Dienste und Tools primär für x86_64 ausgelegt sind. Zudem ermöglicht x86_64 eine höhere CPU-Leistung für mehrere gleichzeitige Nutzer sowie deutlich mehr RAM-Erweiterbarkeit in Richtung 16–32 GB und darüber hinaus.

*Leistung:* Der ARM-Prozessor des Raspberry Pi stößt bei mehreren parallel laufenden Container-Diensten an seine Grenzen. Dies macht sich konkret in längeren Build-Zeiten sowie einer eingeschränkten Skalierbarkeit bemerkbar, sobald mehrere Benutzer gleichzeitig auf die Dienste zugreifen.

*Zuverlässigkeit:* Enterprise-Hardware bietet darüber hinaus eine bessere Zuverlässigkeit und professionellen Support. Dazu gehören ECC-RAM für erhöhte Datensicherheit, redundante Speicheroptionen zum Schutz vor Datenverlust sowie erstklassiger Hardware-Support durch den Hersteller.

*Empfehlung für Produktivbetrieb:* Ein Mini-PC mit x86_64-Architektur, mindestens 16 GB RAM und einer NVMe-SSD wäre für einen produktiven Betrieb deutlich besser geeignet. Der Raspberry Pi ist jedoch ideal für Prototyping und Proof-of-Concept-Projekte, persönliche Hobby-Projekte, Lernumgebungen, Szenarien mit günstiger Beschaffung (vor Hardware-Engpässen) sowie für Setups mit geringer Nutzerlast von ein bis drei gleichzeitigen Benutzern.

=== Dokumentation ist essentiell

Die ausführliche Dokumentation aller Konfigurationsschritte hat sich als wertvoll erwiesen. Durch sie ist die Installation jederzeit reproduzierbar, ohne dass Wissen verloren geht oder Schritte rekonstruiert werden müssen. Bei der Fehlersuche erleichtert eine gute Dokumentation das Nachvollziehen von Konfigurationsentscheidungen erheblich. Innerhalb des Teams dient sie der Wissensvermittlung, damit alle Mitglieder das Gesamtsystem verstehen und weiterentwickeln können. Nicht zuletzt bildet sie die Grundlage für zukünftige Erweiterungen des Systems.

=== Container-Orchestrierung vereinfacht Deployment

Die Verwendung von Podman mit systemd-Quadlets hat mehrere praktische Vorteile gebracht. Da die Container als reguläre systemd-Dienste verwaltet werden, lässt sich das Service-Management mit denselben Werkzeugen wie bei klassischen Linux-Diensten durchführen. Fällt ein Container aus, startet systemd ihn automatisch neu, ohne manuellen Eingriff. Die Isolation der einzelnen Dienste voneinander erhöht die Sicherheit und verhindert, dass Fehler in einem Dienst andere beeinträchtigen. Updates oder Konfigurationsänderungen an einem einzelnen Dienst lassen sich durchführen, ohne den Rest des Systems zu unterbrechen.

=== Offline-First Design erfordert Planung

Die Anforderung, dass alle Dienste ohne Internetverbindung funktionieren müssen, erforderte bewusste Technologie-Entscheidungen bei der Auswahl und Konfiguration jeder Komponente. Alle Dienste speichern ihre Daten lokal, entweder in einer lokalen Datenbank wie SQLite oder direkt auf dem Dateisystem des Servers. Sämtliche Web-Assets wie Skripte, CSS-Dateien und Schriftarten werden lokal ausgeliefert, da Abhängigkeiten von externen CDNs im Offline-Betrieb nicht funktionieren würden. Authentifizierung erfolgt ausschließlich lokal, ohne externe Identity-Provider wie etwa Azure Active Directory, da diese eine Internetverbindung voraussetzen.

=== Hardware-Kompatibilität prüfen

Die SSD-Kompatibilitätsprobleme haben gezeigt, dass auch bei standardisierten Schnittstellen wie M.2 unerwartete Kompatibilitätsprobleme auftreten können. Vor dem Kauf von Hardware-Komponenten sollte daher Community-Feedback zu den gewählten Kombinationen eingeholt und offizielle Kompatibilitätslisten konsultiert werden. Für die Einplanung von Testphasen zur Überprüfung der Kompatibilität vor dem eigentlichen Projektbeginn ist ausreichend Zeit vorzusehen. Darüber hinaus empfiehlt es sich, Alternativoptionen offen zu halten und nicht ausschließlich auf eine einzelne Komponente zu setzen.

#pagebreak()

#set page(numbering: none)

= Quellen

// KI-Hilfsmittel
N. N.: ChatGPT – KI-Assistent. URL: https://chatgpt.com

N. N.: Claude – KI-Assistent. URL: https://claude.ai

// Hardware & Betriebssystem
N. N.: Raspberry Pi – Offizielle Website. URL: https://www.raspberrypi.com

// Protokolle & Standards
N. N.: Wikipedia – Dynamic Host Configuration Protocol (DHCP). URL: https://de.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol

N. N.: Wikipedia – Domain Name System (DNS). URL: https://de.wikipedia.org/wiki/Domain_Name_System

N. N.: Wikipedia – Secure Shell (SSH). URL: https://de.wikipedia.org/wiki/Secure_Shell

// Sprachen & Frameworks
N. N.: OpenSSH – Offizielle Website. URL: https://www.openssh.com

N. N.: Rust – Offizielle Website. URL: https://www.rust-lang.org

N. N.: Python – Offizielle Website. URL: https://www.python.org

N. N.: Flask – Dokumentation. URL: https://flask.palletsprojects.com

N. N.: Actix Web – Dokumentation. URL: https://actix.rs

// Infrastruktur-Tools
N. N.: Podman – Offizielle Website. URL: https://podman.io

N. N.: Caddy – Offizielle Website. URL: https://caddyserver.com

N. N.: hostapd – Dokumentation. URL: https://w1.fi/hostapd/

N. N.: dnsmasq – Dokumentation. URL: https://thekelleys.org.uk/dnsmasq/doc.html

// Eingesetzte Dienste
N. N.: SFTPGo – Projektseite. URL: https://github.com/drakkan/sftpgo

N. N.: Vikunja – Offizielle Website. URL: https://vikunja.io

N. N.: BookStack – Offizielle Website. URL: https://www.bookstackapp.com
