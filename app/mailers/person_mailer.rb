class PersonMailer < ApplicationMailer

  def balance_report(user, csv_data)
    attachments['balance_report.csv'] = {
      mime_type: 'text/csv',
      content: csv_data
    }

    mail(to: user.email, subject: 'Relatório de Saldo')
  end
end