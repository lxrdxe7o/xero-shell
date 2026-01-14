import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../Commons"
import "../../Components"

BasePill {
    id: root

    property var weatherData: ({
        temp: "--",
        condition: "",
        code: "0",
        location: "",
        humidity: "",
        wind: ""
    })

    readonly property bool hasData: weatherData.temp !== "--"

    implicitWidth: weatherRow.implicitWidth + Style.pillPaddingHorizontal * 2
    tooltip: hasData ? weatherData.location + "\nHumidity: " + weatherData.humidity + "\nWind: " + weatherData.wind : "Weather unavailable"

    onClicked: {
        // Refresh weather
        weatherProc.running = true
    }

    // Fetch weather from wttr.in
    Process {
        id: weatherProc
        running: true
        command: ["curl", "-s", "wttr.in/?format=%t|%C|%c|%l|%h|%w"]

        stdout: SplitParser {
            onRead: line => {
                const parts = line.split("|")
                if (parts.length >= 4) {
                    const temp = parts[0].replace("+", "").trim()
                    const condition = parts[1].trim()
                    const icon = parts[2].trim()
                    const location = parts[3].trim()
                    const humidity = parts[4] ? parts[4].trim() : ""
                    const wind = parts[5] ? parts[5].trim() : ""

                    weatherData = {
                        temp: temp,
                        condition: condition,
                        code: getWeatherCode(condition),
                        location: location,
                        humidity: humidity,
                        wind: wind
                    }
                }
            }
        }

        onExited: (code, status) => {
            if (code !== 0) {
                weatherData = {
                    temp: "--",
                    condition: "Error",
                    code: "0",
                    location: "",
                    humidity: "",
                    wind: ""
                }
            }
            restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: Style.weatherPollInterval
        onTriggered: weatherProc.running = true
    }

    Row {
        id: weatherRow
        anchors.centerIn: parent
        spacing: Style.spacingNormal

        // Weather icon
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: getWeatherIcon(root.weatherData.condition)
            color: Colors.pillIcon
            font.pixelSize: Style.fontSizeLarge
            font.family: Style.iconFont

            Behavior on color {
                ColorAnimation { duration: Style.animationFast }
            }
        }

        // Temperature
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.weatherData.temp
            color: Colors.pillText
            font.pixelSize: Style.fontSizeNormal
            font.family: Style.fontFamily
        }
    }

    function getWeatherCode(condition: string): string {
        const c = condition.toLowerCase()
        if (c.includes("sun") || c.includes("clear")) return "0"
        if (c.includes("cloud") || c.includes("overcast")) return "3"
        if (c.includes("fog") || c.includes("mist")) return "45"
        if (c.includes("rain") || c.includes("drizzle") || c.includes("shower")) return "61"
        if (c.includes("snow") || c.includes("sleet")) return "73"
        if (c.includes("thunder") || c.includes("storm")) return "95"
        return "3"
    }

    function getWeatherIcon(condition: string): string {
        const c = condition.toLowerCase()
        if (c.includes("sun") || c.includes("clear")) return Style.iconWeatherSunny
        if (c.includes("cloud") || c.includes("overcast") || c.includes("partly")) return Style.iconWeatherCloudy
        if (c.includes("fog") || c.includes("mist") || c.includes("haze")) return Style.iconWeatherFoggy
        if (c.includes("rain") || c.includes("drizzle") || c.includes("shower")) return Style.iconWeatherRainy
        if (c.includes("snow") || c.includes("sleet") || c.includes("ice")) return Style.iconWeatherSnowy
        if (c.includes("thunder") || c.includes("storm")) return Style.iconWeatherStormy
        if (c.includes("wind")) return Style.iconWeatherWindy
        return Style.iconWeatherCloudy
    }
}
