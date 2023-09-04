import React, { useState } from 'react'
import Signup from './Signup'
import { AiOutlineClose } from 'react-icons/ai'
import UserService from '../services/userApi'
import { ToastContainer, toast } from 'react-toastify';

const Login = (props) => {
    const [showSignup, setShowSignup] = useState(false);
    const [loading, setLoading] = useState(false);

    const handleLogin = async (e) => {
        e.preventDefault();
        setLoading(true);

        var data = {
            userID: e.target.email.value,
            password: e.target.password.value,
            org: e.target.orgs.value
        }

        try {

            let resp = await UserService.Login(data)

            if (resp.status === 200) {
                props.closeModal()
            }

        } catch (error) {
            if (error.response?.status) {
                toast.error(error.response.data)
            } else {
                toast.error(error.message);
            }
        } finally {
            setLoading(false);
        }
    };

    const handleToggleSignup = () => {
        setShowSignup(!showSignup);
    };

    return (
        <div>
            {showSignup ? (
                <Signup closeModal={() => setShowSignup(false)} />
            ) :

                <div className="bg-gray-100 flex flex-col justify-center py-6 sm:px-6 lg:px-8">
                    <div className='flex justify-end'>
                        <div className='rounded-full p-2 hover:bg-red-300 hover:cursor-pointer'>
                            <AiOutlineClose strokeWidth='32' size={22}
                                className='text-red-600 '
                                onClick={props.closeModal} />
                        </div>
                    </div>
                    <div className="sm:mx-auto px-2 sm:w-full sm:max-w-md">
                        <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">Sign in to your account</h2>
                    </div>

                    <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
                        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
                            <form className="space-y-6" onSubmit={handleLogin} >
                                <div>
                                    <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                                        Email address
                                    </label>
                                    <div className="mt-1 text-slate-700">
                                        <input id="email" name="email" type="email" autoComplete="email"
                                            required className="appearance-none block w-full px-3 py-2 border border-gray-300 
                                        rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500
                                         focus:border-blue-500 sm:text-sm" />
                                    </div>
                                </div>

                                <div>
                                    <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                                        Password
                                    </label>
                                    <div className="mt-1  text-slate-700">
                                        <input id="password" name="password" type="password" autoComplete="current-password"
                                            required className="appearance-none block w-full px-3 py-2 border 
                                            border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none 
                                            focus:ring-blue-500 focus:border-blue-500 sm:text-sm" />
                                    </div>
                                </div>

                                <div>
                                    <label htmlFor="orgs" className="block text-sm font-medium text-gray-700">
                                        Select your Organization
                                    </label>
                                    <div className="mt-1  text-slate-700">
                                        <select name="orgs" id="orgs" className='block w-full px-3 py-2 border 
                                            border-gray-300 rounded-md bg-white shadow-sm focus:outline-none 
                                            focus:ring-blue-500 focus:border-blue-500 sm:text-sm'>
                            <option value="hospital">hospital</option>
                            <option value="pharmacy">pharmacy</option>
                            <option value="laboratory">laboratory</option>

                                        </select>
                                    </div>
                                </div>

                                <div className="flex items-center justify-between">
                                    <div className="text-sm">
                                        <a href="#" className="font-medium text-blue-600 hover:text-blue-500">
                                            Forgot your password?
                                        </a>
                                    </div>
                                    <div>
                                        <span className='text-sm text-blue-600 hover:text-blue-500 font-medium hover:cursor-pointer'
                                            onClick={handleToggleSignup}>New User?</span>
                                    </div>
                                </div>

                                <div>
                                    {
                                        !loading ?
                                            <button type="submit" className="w-full flex justify-center py-2 px-4 border border-transparent 
                                            rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 
                                            focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                                Sign in
                                            </button>
                                            : <button className='rounded-md bg-blue-200 inline-flex px-5 py-2 shadow-md w-full justify-center' disabled>
                                                <span className="relative flex h-3 w-3 mr-2">
                                                    <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-sky-400 opacity-75"></span>
                                                    <span className="relative inline-flex rounded-full h-3 w-3 bg-sky-500"></span>
                                                </span>
                                                Signing in...</button>
                                    }

                                </div>
                            </form>
                        </div>
                    </div>
                </div>}
        </div>
    )
}

export default Login
