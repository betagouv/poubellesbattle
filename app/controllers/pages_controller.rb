class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def vieprivee; end

  def stats
    # this day but last month
    last_month = Date.today - 1.month
    last_last_month = Date.today - 2.month
    # nombre d'inscrits sur la plateforme
    users = User.all
    @stats = []
    users_count = users.count
    users_last_month = users.created_before(last_month).count
    users_last_last_month = users.created_before(last_last_month).count
    users_evol = (((users_count.to_f - users_last_month.to_f)/ users_count.to_f) * 100).round

    next_month = I18n.t("date.month_names")[(Date.today + 1.month).month]
    this_month_full = I18n.t("date.month_names")[Date.today.month]
    last_month_full = I18n.t("date.month_names")[(Date.today - 1.month).month]
    last_last_month_full = I18n.t("date.month_names")[(Date.today - 2.month).month]

    # Options for all charts
    green = "#4FB571"
    yellow = "#FFC65A"
    brown = "#986535"

    @options = {
      scales: {
        yAxes: [{
          id: 'first-y-axis',
          type: 'linear',
          ticks: { stepSize: 5 }
        }]
      },
      legend: {
        display: false
      },
      height: 200,
      width: 660
    }
    @options_line_bar = {
      tooltips: {
        afterBody: "litres"
      },
      legend: {
        display: false
      },
      height: 200,
      width: 660
    }
    @options_doughnut = {
      height: 250,
      width: 250
    }

    # users chart
    @users_stats = {
      labels: ["#{last_last_month_full}", "#{last_month_full}", "#{this_month_full}"],
      datasets: [
        {
          backgroundColor: yellow,
          borderColor: green,
          borderWidth: 10,
          pointBorderColor: brown,
          pointBackgroundColor: yellow,
          pointRadius: 6,
          pointBorderWidth: 2,
          data: [users_last_last_month, users_last_month, users_count]
        }
      ]
    }
    # composteurs chart
    composteurs = Composteur.all
    # nombre de nouveau composteur since 01-01-2020
    composteurs_count = composteurs.count
    # # evolution since premier seed == 53
    composteurs_last_month = composteurs.created_before(last_month).count
    composteurs_last_last_month = composteurs.created_before(last_last_month).count
    composteurs_evol = (((composteurs_count - composteurs_last_last_month)/ composteurs_count.to_f) * 100).round
    # # moyenne nombre / site
    users_per_composteur = users_count.fdiv(composteurs_count).round(2)

    @composteurs_stats = {
      labels: ["#{last_last_month_full}", "#{last_month_full}", "#{this_month_full}",],
      datasets: [
        {
          backgroundColor: brown,
          borderColor: green,
          borderWidth: 10,
          pointBorderColor: yellow,
          pointBackgroundColor: brown,
          pointRadius: 6,
          pointBorderWidth: 2,
          data: [composteurs_last_last_month, composteurs_last_month,composteurs_count]
        }
      ]
    }

    notifications = Notification.all
    # # nombre d'anomalies total
    anomalies = notifications.where(notification_type: "anomalie")
    anomalies_count = anomalies.count
    resolved_anomalies_count = notifications.where(resolved: true).count
    # # nombre de depots declares (evolution sur les 3 derniers mois ?)
    depots_count = notifications.where(notification_type: "depot").count
    # # nombre de messages echanges
    messages_count = notifications.count - anomalies_count - depots_count

    @notifications_stats = {
      labels: ["Anomalies résolues", "Dépots signalés", "Messages échangés"],
      datasets: [
        {
          backgroundColor: [yellow, brown, green],
          borderColor: "white",
          data: [anomalies_count, depots_count, messages_count]
        }
      ]
    }


    demandes = Demande.all
    demandes_count = demandes.count
    demandes_last_month = demandes.created_before(last_month).count
    demandes_last_last_month = demandes.created_before(last_last_month).count

    @demandes_stats = {
      labels: ["#{last_last_month_full}", "#{last_month_full}", "#{this_month_full}",],
      datasets: [
        {
          backgroundColor: green,
          pointBackgroundColor: green,
          borderColor: yellow,
          borderWidth: 10,
          pointBorderColor: brown,
          pointRadius: 6,
          pointBorderWidth: 2,
          data: [demandes_last_last_month, demandes_last_month, demandes_count]
        }
      ]
    }
    # # nombre d'annonces publiees sur la bourse verte
    donverts = Donvert.all
    @donverts_count = donverts.count
    # # volume de matiere echangee ? annonces pourvues x volume par annonce ?
    volume_compost = 0
    volume_structurant = 0
    donverts.where.not(type_matiere_orga: "outils").each do |don|
      if don.pourvu
        don.type_matiere_orga == "compost" ? volume_compost += don.volume_litres : volume_compost
        don.type_matiere_orga == "structurant" ? volume_structurant += don.volume_litres : volume_structurant
      end
    end
    @volume_total = volume_compost + volume_structurant
    @volume_stats = {
      labels: ["Compost", "Structurant"],
      datasets: [
        {
          backgroundColor: [green, yellow],
          data: [volume_structurant, volume_compost]
        }
      ]
    }

    # # frequentation globale ? matomo api ?
  end
end
