package app.goalpilot

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

class DailyFuelWidgetReceiver : HomeWidgetGlanceWidgetReceiver<DailyFuelWidget>() {
    override val glanceAppWidget = DailyFuelWidget()
}
