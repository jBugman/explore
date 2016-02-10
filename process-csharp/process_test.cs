using System;
using System.Collections.Generic;
using NUnit.Framework;

namespace ProcessCsharpTests {

    [TestFixture()]
    public class ProcessCsharpTest {

        [Test()]
        public void ShouldWork() {
            Assert.AreEqual(ProcessCsharp.Process("Name", "../../test_data"), ProcessCsharp.SUCCESS);
        }
    }
}
