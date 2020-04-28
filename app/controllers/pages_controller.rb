class PagesController < ApplicationController
  require 'csv'

  skip_before_action :authenticate_user!
  before_action :user_admin?
  # skip_before_action :user_admin?, only: :stats
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def stats
    # this day but last month
    last_month = Date.today - 1.month
    last_last_month = Date.today - 2.month
    # nombre d'inscrits sur la plateforme
    users = User.all
    @stats = []
    @users_count = users.count
    users_last_month = users.created_before(last_month).count
    users_last_last_month = users.created_before(last_last_month).count
    users_evol = (((@users_count.to_f - users_last_month.to_f)/ @users_count.to_f) * 100).round

    @next_month = I18n.t("date.month_names")[(Date.today + 1.month).month]
    @this_month_full = I18n.t("date.month_names")[Date.today.month]
    last_month_full = I18n.t("date.month_names")[(Date.today - 1.month).month]
    last_last_month_full = I18n.t("date.month_names")[(Date.today - 2.month).month]
    ## Trying chartjs
    # Options for all charts
    @options = {
      # id: "chart_composteurs",
      legend: {
        display: false,
      },
      height: 200,
      width: 900
    }
    @options_doughnut = {
      # id: "chart_composteurs",

      height: 250,
      width: 250
    }
    #users chart
    @users_stats = {
      labels: ["#{last_last_month_full}", "#{last_month_full}", "#{@this_month_full}"],
      datasets: [
        {
          backgroundColor: "transparent",
          borderColor: "red",
          data: [users_last_last_month, users_last_month, @users_count]
        }
      ]
    }
    # composteurs chart
    composteurs = Composteur.all
    # nombre de nouveau composteur since 01-01-2020
    @composteurs_count = composteurs.count
    # # evolution since premier seed == 53
    composteurs_last_month = composteurs.created_before(last_month).count
    composteurs_last_last_month = composteurs.created_before(last_last_month).count
    composteurs_evol = (((@composteurs_count - composteurs_last_last_month)/ @composteurs_count.to_f) * 100).round
    # # moyenne nombre / site
    users_per_composteur = @users_count.fdiv(@composteurs_count).round(2)

    @composteurs_stats = {
      labels: ["#{last_last_month_full}", "#{last_month_full}", "#{@this_month_full}",],
      datasets: [
          {
            backgroundColor: "transparent",
            borderColor: "blue",
            data: [composteurs_last_last_month, composteurs_last_month, @composteurs_count]
          }
        ]
      }

    notifications = Notification.all
    # # nombre d'anomalies total
    anomalies = notifications.where(notification_type: "anomalie")
    anomalies_count = anomalies.count
    # anomalies_last_month = anomalies.created_before(last_month).count
    # anomalies_last_last_month = anomalies.created_before(last_last_month).count
    # # nombre d'anomalies resolues
    resolved_anomalies_count = notifications.where(resolved: true).count
    # # nombre de depots declares (evolution sur les 3 derniers mois ?)
    depots_count = notifications.where(notification_type: "depot").count
    # # nombre de messages echanges
    messages_count = notifications.count - anomalies_count - depots_count

    @notifications_stats = {
      labels: ["Anomalies résolues", "Dépots signalés", "Messages échangés"],
      datasets: [
        {
          backgroundColor: ["#FFC65A", "#986535", "#4FB571"],
          borderColor: "transparent",
          data: [anomalies_count, depots_count, messages_count]
        }
      ]
    }
    # # nombre d'annonces publiees sur la bourse verte
    donverts = Donvert.all
    donverts_count = donverts.count
    # # volume de matiere echangee ? annonces pourvues x volume par annonce ?
    volume_total = 0
    donverts.where.not(type_matiere_orga: "outils").each do |don|
      don.pourvu ? volume_total += don.volume_litres : volume_total
    end
    # # frequentation globale ? matomo api ?
    # # nombre de demande de composteurs/mois
    demandes = Demande.all
    demandes_count = demandes.count
    demandes_this_month = demandes.created_after(last_month).count
    # # ratio demandes / nouveaux composteurs
    ratio_demande_vs_new = ((composteurs.created_after(last_month).count / demandes_this_month) * 100).round
    # # nombre de notifications total

    ## building @stats
    # @stats << ["number", "Nombre d'inscrit•e•s", @users_count]
    # @stats << ["number", "Nombre d'inscrit•e•s le mois dernier", users_last_month]
    # @stats << ["percent large-card", "Progression des inscriptions depuis le mois dernier", users_evol]
    # @stats << ["number", "Nombre de d'inscrit•e•s par site de compostage", users_per_composteur]
    # @stats << ["number", "Nombre de sites de compostage", @composteurs_count]
    # @stats << ["number", "Nombre de sites le mois dernier", composteurs_last_month]
    # @stats << ["number large-card", "Progression du nombre de site de compostage", composteurs_evol]
    @stats << ["number", "Nombre d'annonces publiées sur la Bourse Verte", donverts_count]
    @stats << ["volume", "Volume total de matière échangée", "#{volume_total} L"]
    @stats << ["number", "Nombre total de demandes d'installation", demandes_count]
    @stats << ["number", "Nombre de demandes d'installation ce mois", demandes_this_month]
    @stats << ["percent", "Ratio de demandes transformées en site de compostage", ratio_demande_vs_new]
    @stats << ["number", "Nombre d'anomalie signalée sur les sites de compostage", anomalies_count]
    @stats << ["number", "Nombre d'anomalies résolues", resolved_anomalies_count]
    @stats << ["number", "Nombre de dépôts effectués", depots_count]
    @stats << ["number", "Nombre de messages échangés par la communauté Poubelles Battle", messages_count]
  end

  def annuaire
    @composteurs = Composteur.all
    @users = User.all
    if params[:query].present?
      @users_list = @users.search_by_first_name_and_last_name(params[:query])
    else
      @users_list = @users
    end
  end

  def users_export
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv }
    end
  end

  def users_newsletter
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv_newsletter }
    end
  end
end
