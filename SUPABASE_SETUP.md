# Supabase Setup Guide

This guide will help you set up Supabase authentication for your Flutter app.

## Step 1: Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in to your account
3. Click "New Project"
4. Choose your organization
5. Enter a project name and database password
6. Choose a region close to your users
7. Click "Create new project"

## Step 2: Get Your Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy your **Project URL** and **anon public** key
3. Update the `lib/config/supabase_config.dart` file with your credentials:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_PROJECT_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
}
```

## Step 3: Configure Authentication

1. In your Supabase dashboard, go to **Authentication** → **Settings**
2. Under **Site URL**, add your app's URL:
   - For development: `http://localhost:3000`
   - For production: Your actual domain
3. Under **Redirect URLs**, add:
   - `http://localhost:3000/auth/callback`
   - `http://localhost:8080/auth/callback` (for Flutter web)
   - Your production callback URLs

## Step 4: Enable Email Authentication

1. Go to **Authentication** → **Providers**
2. Make sure **Email** is enabled
3. Configure email templates if needed

## Step 5: Test the Integration

1. Run your Flutter app: `flutter run`
2. Try creating a new account
3. Check your email for verification
4. Test logging in and out

## Features Included

- ✅ Email/Password authentication
- ✅ User registration
- ✅ Email verification
- ✅ Secure session management
- ✅ Automatic login state handling
- ✅ Logout functionality

## Troubleshooting

### Common Issues:

1. **"Invalid API key" error**: Make sure you're using the anon key, not the service role key
2. **Email not sending**: Check your Supabase project's email settings
3. **Redirect errors**: Verify your redirect URLs in Supabase settings
4. **CORS errors**: Make sure your site URL is correctly configured

### Getting Help:

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Supabase Community](https://github.com/supabase/supabase/discussions)

## Security Notes

- Never commit your service role key to version control
- Use environment variables for production deployments
- Regularly rotate your API keys
- Enable Row Level Security (RLS) on your database tables 