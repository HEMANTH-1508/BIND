
struct APIHandler
{
    static let baseURL = "http://localhost/bind_php/"

    static let login = baseURL + "login.php"
    static let signUp = baseURL + "signup.php"
    static let eventList = baseURL + "event_list.php"
    static let addEvent = baseURL + "add_event.php"
    static let deleteEvent = baseURL + "delete_event.php"
    static let addData = baseURL + "add_data.php"
    static let getData = baseURL + "get_data.php"
    static let deleteData = baseURL + "delete_data.php"
    static let forgotPassword = baseURL + "forgot_password.php"
    static let resetPassword = baseURL + "reset_password.php"
    static let changePassword = baseURL + "change_password.php"
    static let changeUserName = baseURL + "change_username.php"
    static let deleteUser = baseURL + "delete_account.php"
    static let quote = baseURL + "quote.php"
    static let getUsername = baseURL + "get_username.php"
    
}
