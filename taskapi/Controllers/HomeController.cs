using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using aisazdevspace_taskapi.Models;

namespace aisazdevspace_taskapi.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }
        /*public IActionResult About()
        {
            string dateTime = DateTime.Now.ToString(); 
            ViewData["Message"] = @"This is a Sample Application used for the Azure Dev Spaces Demo. Testing the Code deployment from Development Machine after adding this 
            comments in HomeController.cs file! This change will be updated into the container after running the 'azds up' command. Debugging in the AKS Container. 
            Current time in Container is " + dateTime;
             
            return View();
        }*/

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
