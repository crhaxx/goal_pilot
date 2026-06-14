package app.goalpilot

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class DailyFuelWidget : GlanceAppWidget() {

    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceTheme {
                DailyFuelContent(context, currentState())
            }
        }
    }
}

@Composable
private fun DailyFuelContent(context: Context, currentState: HomeWidgetGlanceState) {
    val prefs = currentState.preferences
    val today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE)

    val quoteDate = prefs.getString(KEY_QUOTE_DATE, "")
    val scheduledDate = prefs.getString(KEY_SCHEDULED_DATE, "")

    val (quote, goalTitle) = when {
        quoteDate == today -> {
            prefs.getString(KEY_QUOTE, "") to prefs.getString(KEY_GOAL_TITLE, "")
        }
        scheduledDate == today -> {
            prefs.getString(KEY_SCHEDULED_QUOTE, "") to
                prefs.getString(KEY_SCHEDULED_GOAL_TITLE, "")
        }
        else -> {
            "" to ""
        }
    }

    val displayQuote = quote?.takeIf { it.isNotBlank() }
        ?: context.getString(R.string.daily_fuel_widget_fallback)
    val displayGoal = goalTitle?.takeIf { it.isNotBlank() }

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(ColorProvider(Color(0xFF0F172A)))
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.Vertical.CenterVertically,
        horizontalAlignment = Alignment.Horizontal.Start,
    ) {
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.Vertical.CenterVertically,
            horizontalAlignment = Alignment.Horizontal.Start,
        ) {
            Text(
                text = context.getString(R.string.app_name),
                style = TextStyle(
                    color = ColorProvider(Color(0xFF06B6D4)),
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Start,
                ),
                maxLines = 1,
            )
            Text(
                text = " · ${context.getString(R.string.daily_fuel_widget_brand_subtitle)}",
                style = TextStyle(
                    color = ColorProvider(Color(0xFF64748B)),
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Normal,
                    textAlign = TextAlign.Start,
                ),
                maxLines = 1,
            )
        }
        Text(
            text = displayQuote,
            modifier = GlanceModifier.padding(top = 8.dp),
            style = TextStyle(
                color = ColorProvider(Color(0xFFF1F5F9)),
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium,
                textAlign = TextAlign.Start,
            ),
            maxLines = 4,
        )
        if (displayGoal != null) {
            Text(
                text = displayGoal,
                modifier = GlanceModifier.padding(top = 6.dp),
                style = TextStyle(
                    color = ColorProvider(Color(0xFF06B6D4)),
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Normal,
                    textAlign = TextAlign.Start,
                ),
                maxLines = 1,
            )
        }
    }
}

private const val KEY_QUOTE = "daily_fuel_quote"
private const val KEY_GOAL_TITLE = "daily_fuel_goal_title"
private const val KEY_QUOTE_DATE = "daily_fuel_date"
private const val KEY_SCHEDULED_QUOTE = "scheduled_quote"
private const val KEY_SCHEDULED_GOAL_TITLE = "scheduled_goal_title"
private const val KEY_SCHEDULED_DATE = "scheduled_date"
